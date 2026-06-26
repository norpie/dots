/**
 * Generic sub-agent factory.
 * Spawns `pi -p` with a restricted toolset, streams progress, renders results.
 */

import { spawn } from "node:child_process";
import * as fs from "node:fs";
import * as path from "node:path";
import type { AgentToolResult } from "@mariozechner/pi-agent-core";
import type { Message } from "@mariozechner/pi-ai";
import { type ExtensionAPI, getMarkdownTheme } from "@mariozechner/pi-coding-agent";
import { Container, Markdown, Spacer, Text } from "@mariozechner/pi-tui";
import { Type } from "@sinclair/typebox";

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

export interface SubAgentConfig {
	name: string;
	label: string;
	description: string;
	tools: string[];
	systemPrompt?: string;
	extraArgs?: string[];
}

interface SubAgentDetails {
	messages: Message[];
	stderr: string;
	model?: string;
	timeline: DisplayItem[];
	usage: { input: number; output: number; cacheRead: number; cacheWrite: number; cost: number; turns: number };
}

type DisplayItem =
	| { type: "text"; text: string }
	| { type: "thinking"; text: string }
	| { type: "toolCall"; name: string; args: Record<string, any> };

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

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

// ---------------------------------------------------------------------------
// Factory
// ---------------------------------------------------------------------------

export function createSubAgentTool(config: SubAgentConfig) {
	return {
		name: config.name,
		label: config.label,
		description: config.description,
		parameters: Type.Object({
			prompt: Type.String({ description: `Detailed prompt for the ${config.name} sub-agent` }),
		}),

		async execute(_toolCallId: string, params: { prompt: string }, signal: AbortSignal | undefined, onUpdate: ((result: AgentToolResult) => void) | undefined, ctx: { cwd: string }) {
			const details: SubAgentDetails = {
				messages: [],
				stderr: "",
				timeline: [],
				usage: { input: 0, output: 0, cacheRead: 0, cacheWrite: 0, cost: 0, turns: 0 },
			};

			let currentThinking = "";

			const emitUpdate = () => {
				onUpdate?.({
					content: [{ type: "text", text: getFinalOutput(details.messages) || `(${config.name}ing...)` }],
					details: { ...details },
				});
			};

			const fullPrompt = config.systemPrompt
				? `${config.systemPrompt}\n\n${params.prompt}`
				: params.prompt;

			const piArgs: string[] = [
				"--mode", "json",
				"-p",
				"--no-session",
				"-ns",
				"--tools", config.tools.join(","),
				...(config.extraArgs ?? []),
				fullPrompt,
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

					if (event.type === "message_update" && event.assistantMessageEvent) {
						const ame = event.assistantMessageEvent;
						if (ame.type === "thinking_delta") {
							currentThinking += ame.delta || "";
						}
					}

					if (event.type === "message_end" && event.message) {
						const msg = event.message as Message;
						details.messages.push(msg);

						if (msg.role === "assistant") {
							if (currentThinking.trim()) {
								details.timeline.push({ type: "thinking", text: currentThinking.trim() });
							}
							currentThinking = "";

							for (const part of msg.content) {
								if (part.type === "toolCall") {
									details.timeline.push({ type: "toolCall", name: part.name, args: part.arguments });
								}
							}

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

			if (wasAborted) throw new Error(`${config.label} sub-agent was aborted`);

			const output = getFinalOutput(details.messages);

			if (exitCode !== 0 && !output) {
				return {
					content: [{ type: "text", text: `${config.label} failed (exit ${exitCode}): ${details.stderr || "(no output)"}` }],
					details,
					isError: true,
				};
			}

			return {
				content: [{ type: "text", text: output || "(no output)" }],
				details,
			};
		},

		renderCall(args: { prompt: string }, theme: any, _context: any) {
			const preview = args.prompt
				? (args.prompt.length > 80 ? args.prompt.slice(0, 80) + "..." : args.prompt)
				: "...";
			return new Text(
				theme.fg("toolTitle", theme.bold(`${config.name} `)) + theme.fg("dim", preview),
				0, 0,
			);
		},

		renderResult(result: AgentToolResult, { expanded }: { expanded: boolean }, theme: any, _context: any) {
			const details = result.details as SubAgentDetails | undefined;
			if (!details || details.messages.length === 0) {
				const t = result.content[0];
				return new Text(t?.type === "text" ? t.text : "(no output)", 0, 0);
			}

			const timeline = details.timeline;
			const finalOutput = getFinalOutput(details.messages);
			const fg = theme.fg.bind(theme);

			const parts: string[] = [];
			if (details.usage.turns) parts.push(`${details.usage.turns} turn${details.usage.turns > 1 ? "s" : ""}`);
			if (details.usage.input) parts.push(`↑${formatTokens(details.usage.input)}`);
			if (details.usage.output) parts.push(`↓${formatTokens(details.usage.output)}`);
			if (details.usage.cost) parts.push(`$${details.usage.cost.toFixed(4)}`);
			if (details.model) parts.push(details.model);
			const usageLine = parts.join(" ");

			if (expanded) {
				const container = new Container();
				container.addChild(new Text(fg("success", "✓ ") + fg("toolTitle", theme.bold(`${config.name} `)), 0, 0));

				for (const item of timeline) {
					if (item.type === "thinking") {
						container.addChild(new Spacer(1));
						container.addChild(new Text(fg("muted", theme.bold("thinking")), 0, 0));
						container.addChild(new Text(fg("muted", item.text.trim()), 0, 0));
					} else if (item.type === "toolCall") {
						container.addChild(new Text(fg("muted", "→ ") + formatToolCall(item.name, item.args, fg), 0, 0));
					}
				}

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

			const toolCalls = timeline.filter((i) => i.type === "toolCall");
			const SHOW = 10;
			const toShow = toolCalls.slice(-SHOW);
			const skipped = toolCalls.length > SHOW ? toolCalls.length - SHOW : 0;

			let text = fg("success", "✓ ") + fg("toolTitle", theme.bold(`${config.name} `));
			if (skipped > 0) text += "\n" + fg("muted", `... ${skipped} earlier tool call${skipped > 1 ? "s" : ""}`);
			for (const item of toShow) {
				if (item.type === "toolCall") {
					text += "\n" + fg("muted", "→ ") + formatToolCall(item.name, item.args, fg);
				}
			}
			if (usageLine) text += "\n" + fg("dim", usageLine);

			return new Text(text, 0, 0);
		},
	};
}
