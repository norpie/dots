/**
 * Minimal research sub-agent.
 * One tool: "research". Takes a prompt, spawns `pi -p`, streams progress live.
 */

import { spawn } from "node:child_process";
import * as fs from "node:fs";
import * as path from "node:path";
import type { AgentToolResult } from "@mariozechner/pi-agent-core";
import type { Message } from "@mariozechner/pi-ai";
import { type ExtensionAPI, getMarkdownTheme } from "@mariozechner/pi-coding-agent";
import { Container, Markdown, Spacer, Text } from "@mariozechner/pi-tui";
import { Type } from "@sinclair/typebox";

interface ResearchDetails {
	messages: Message[];
	stderr: string;
	model?: string;
	usage: { input: number; output: number; cacheRead: number; cacheWrite: number; cost: number; turns: number };
}

function formatTokens(n: number): string {
	if (n < 1000) return n.toString();
	if (n < 10000) return `${(n / 1000).toFixed(1)}k`;
	if (n < 1000000) return `${Math.round(n / 1000)}k`;
	return `${(n / 1000000).toFixed(1)}M`;
}

function getFinalOutput(messages: Message[]): string {
	for (let i = messages.length - 1; i >= 0; i--) {
		const msg = messages[i];
		if (msg.role === "assistant") {
			for (const part of msg.content) {
				if (part.type === "text") return part.text;
			}
		}
	}
	return "";
}

type DisplayItem = { type: "text"; text: string } | { type: "toolCall"; name: string; args: Record<string, any> };

function getDisplayItems(messages: Message[]): DisplayItem[] {
	const items: DisplayItem[] = [];
	for (const msg of messages) {
		if (msg.role === "assistant") {
			for (const part of msg.content) {
				if (part.type === "text") items.push({ type: "text", text: part.text });
				else if (part.type === "toolCall") items.push({ type: "toolCall", name: part.name, args: part.arguments });
			}
		}
	}
	return items;
}

function formatToolCall(name: string, args: Record<string, unknown>, fg: (c: any, t: string) => string): string {
	const home = process.env.HOME || "";
	const short = (p: string) => (p.startsWith(home) ? `~${p.slice(home.length)}` : p);

	switch (name) {
		case "bash": {
			const cmd = (args.command as string) || "...";
			return fg("muted", "$ ") + fg("toolOutput", cmd.length > 80 ? cmd.slice(0, 80) + "..." : cmd);
		}
		case "read": {
			const p = short((args.file_path || args.path || "...") as string);
			return fg("muted", "read ") + fg("accent", p);
		}
		case "grep": {
			const pattern = (args.pattern || "") as string;
			const p = short((args.path || ".") as string);
			return fg("muted", "grep ") + fg("accent", `/${pattern}/`) + fg("dim", ` in ${p}`);
		}
		case "find": {
			const pattern = (args.pattern || "*") as string;
			const p = short((args.path || ".") as string);
			return fg("muted", "find ") + fg("accent", pattern) + fg("dim", ` in ${p}`);
		}
		default: {
			const s = JSON.stringify(args);
			return fg("accent", name) + fg("dim", ` ${s.length > 60 ? s.slice(0, 60) + "..." : s}`);
		}
	}
}

function getPiInvocation(args: string[]): { command: string; args: string[] } {
	const currentScript = process.argv[1];
	if (currentScript && fs.existsSync(currentScript)) {
		return { command: process.execPath, args: [currentScript, ...args] };
	}
	const execName = path.basename(process.execPath).toLowerCase();
	if (!/^(node|bun)(\.exe)?$/.test(execName)) {
		return { command: process.execPath, args };
	}
	return { command: "pi", args };
}

export default function (pi: ExtensionAPI) {
	pi.registerTool({
		name: "research",
		label: "Research",
		description:
			"Delegate a research task to a sub-agent with an isolated context window. " +
			"The sub-agent can read files and run commands but cannot edit or write. " +
			"Use this for: tracing code flows, finding usages, exploring unfamiliar code, " +
			"answering questions that require reading many files. " +
			"Provide a detailed prompt describing exactly what to find.",
		parameters: Type.Object({
			prompt: Type.String({ description: "Detailed research prompt for the sub-agent" }),
		}),

		async execute(_toolCallId, params, signal, onUpdate, ctx) {
			const details: ResearchDetails = {
				messages: [],
				stderr: "",
				usage: { input: 0, output: 0, cacheRead: 0, cacheWrite: 0, cost: 0, turns: 0 },
			};

			const emitUpdate = () => {
				onUpdate?.({
					content: [{ type: "text", text: getFinalOutput(details.messages) || "(researching...)" }],
					details: { ...details },
				});
			};

			const piArgs = [
				"--mode", "json",
				"-p",
				"--no-session",
				"-ne", "-ns",
				"--tools", "read,bash,grep,find,ls",
				params.prompt,
			];

			let wasAborted = false;

			const exitCode = await new Promise<number>((resolve) => {
				const invocation = getPiInvocation(piArgs);
				const proc = spawn(invocation.command, invocation.args, {
					cwd: ctx.cwd,
					shell: false,
					stdio: ["ignore", "pipe", "pipe"],
				});

				let buffer = "";

				const processLine = (line: string) => {
					if (!line.trim()) return;
					let event: any;
					try { event = JSON.parse(line); } catch { return; }

					if (event.type === "message_end" && event.message) {
						const msg = event.message as Message;
						details.messages.push(msg);

						if (msg.role === "assistant") {
							details.usage.turns++;
							const u = msg.usage;
							if (u) {
								details.usage.input += u.input || 0;
								details.usage.output += u.output || 0;
								details.usage.cacheRead += u.cacheRead || 0;
								details.usage.cacheWrite += u.cacheWrite || 0;
								details.usage.cost += u.cost?.total || 0;
							}
							if (!details.model && msg.model) details.model = msg.model;
						}
						emitUpdate();
					}

					if (event.type === "tool_result_end" && event.message) {
						details.messages.push(event.message as Message);
						emitUpdate();
					}
				};

				proc.stdout.on("data", (data) => {
					buffer += data.toString();
					const lines = buffer.split("\n");
					buffer = lines.pop() || "";
					for (const line of lines) processLine(line);
				});

				proc.stderr.on("data", (data) => {
					details.stderr += data.toString();
				});

				proc.on("close", (code) => {
					if (buffer.trim()) processLine(buffer);
					resolve(code ?? 0);
				});

				proc.on("error", () => resolve(1));

				if (signal) {
					const kill = () => {
						wasAborted = true;
						proc.kill("SIGTERM");
						setTimeout(() => { if (!proc.killed) proc.kill("SIGKILL"); }, 5000);
					};
					if (signal.aborted) kill();
					else signal.addEventListener("abort", kill, { once: true });
				}
			});

			if (wasAborted) throw new Error("Research sub-agent was aborted");

			const output = getFinalOutput(details.messages);

			if (exitCode !== 0 && !output) {
				return {
					content: [{ type: "text", text: `Research failed (exit ${exitCode}): ${details.stderr || "(no output)"}` }],
					details,
					isError: true,
				};
			}

			return {
				content: [{ type: "text", text: output || "(no output)" }],
				details,
			};
		},

		renderCall(args, theme, _context) {
			const preview = args.prompt
				? (args.prompt.length > 80 ? args.prompt.slice(0, 80) + "..." : args.prompt)
				: "...";
			return new Text(
				theme.fg("toolTitle", theme.bold("research ")) + theme.fg("dim", preview),
				0, 0,
			);
		},

		renderResult(result, { expanded }, theme, _context) {
			const details = result.details as ResearchDetails | undefined;
			if (!details || details.messages.length === 0) {
				const t = result.content[0];
				return new Text(t?.type === "text" ? t.text : "(no output)", 0, 0);
			}

			const items = getDisplayItems(details.messages);
			const finalOutput = getFinalOutput(details.messages);
			const fg = theme.fg.bind(theme);

			// Usage line
			const parts: string[] = [];
			if (details.usage.turns) parts.push(`${details.usage.turns} turn${details.usage.turns > 1 ? "s" : ""}`);
			if (details.usage.input) parts.push(`↑${formatTokens(details.usage.input)}`);
			if (details.usage.output) parts.push(`↓${formatTokens(details.usage.output)}`);
			if (details.usage.cost) parts.push(`$${details.usage.cost.toFixed(4)}`);
			if (details.model) parts.push(details.model);
			const usageLine = parts.join(" ");

			if (expanded) {
				const container = new Container();
				container.addChild(new Text(fg("success", "✓ ") + fg("toolTitle", theme.bold("research")), 0, 0));

				// Show tool calls
				for (const item of items) {
					if (item.type === "toolCall") {
						container.addChild(new Text(fg("muted", "→ ") + formatToolCall(item.name, item.args, fg), 0, 0));
					}
				}

				// Final output as markdown
				if (finalOutput) {
					container.addChild(new Spacer(1));
					container.addChild(new Markdown(finalOutput.trim(), 0, 0, getMarkdownTheme()));
				}

				if (usageLine) {
					container.addChild(new Spacer(1));
					container.addChild(new Text(fg("dim", usageLine), 0, 0));
				}
				return container;
			}

			// Collapsed: last N tool calls + usage
			const SHOW = 10;
			const toShow = items.slice(-SHOW);
			const skipped = items.length > SHOW ? items.length - SHOW : 0;

			let text = fg("success", "✓ ") + fg("toolTitle", theme.bold("research"));
			if (skipped > 0) text += "\n" + fg("muted", `... ${skipped} earlier items`);
			for (const item of toShow) {
				if (item.type === "toolCall") {
					text += "\n" + fg("muted", "→ ") + formatToolCall(item.name, item.args, fg);
				} else {
					const preview = item.text.split("\n").slice(0, 2).join("\n");
					text += "\n" + fg("toolOutput", preview);
				}
			}
			if (usageLine) text += "\n" + fg("dim", usageLine);

			return new Text(text, 0, 0);
		},
	});
}
