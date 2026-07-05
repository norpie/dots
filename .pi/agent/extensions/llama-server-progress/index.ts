/**
 * llama-server provider with prompt-progress integration.
 *
 * Sends `return_progress: true` to llama-server and feeds the
 * `prompt_progress` SSE field back into pi's working-message loader
 * so the TUI shows "Evaluating prompt… 43 % (0 cached)" instead of
 * a static "Evaluating prompt…" message.
 *
 * Place: ~/.pi/agent/extensions/llama-server-progress/index.ts
 */

import {
	createAssistantMessageEventStream,
} from "@earendil-works/pi-ai";
import type {
	Api,
	AssistantMessage,
	AssistantMessageEventStream,
	Context,
	ImageContent,
	Message,
	Model,
	SimpleStreamOptions,
	StopReason,
	TextContent,
	ThinkingContent,
	Tool,
	ToolCall,
	ToolResultMessage,
} from "@earendil-works/pi-ai";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import * as fs from "node:fs";
import * as path from "node:path";

// ---------------------------------------------------------------------------
// TOML parser for models-extra-params.toml
// ---------------------------------------------------------------------------

function parseParamsTOML(raw: string): Map<string, Record<string, unknown>> {
	const map = new Map<string, Record<string, unknown>>();
	let currentSection: string | null = null;
	let currentRecord: Record<string, unknown> = {};

	for (const line of raw.split("\n")) {
		const trimmed = line.trim();
		if (!trimmed || trimmed.startsWith("#") || trimmed.startsWith(";")) continue;

		const sectionMatch = trimmed.match(/^\[([^\]]+)\]$/);
		if (sectionMatch) {
			if (currentSection !== null) {
				map.set(currentSection, currentRecord);
			}
			currentSection = sectionMatch[1].trim();
			currentRecord = {};
			continue;
		}

		const eqIndex = trimmed.indexOf("=");
		if (eqIndex !== -1) {
			const key = trimmed.slice(0, eqIndex).trim();
			let value = trimmed.slice(eqIndex + 1).trim();

			const commentIdx = value.indexOf("#");
			if (commentIdx !== -1) value = value.slice(0, commentIdx).trim();

			if (value === "true") value = true;
			else if (value === "false") value = false;
			else if (!isNaN(Number(value)) && (value.includes(".") || value.startsWith("-") || /^\d+$/.test(value))) {
				value = Number(value);
			} else if ((value.startsWith('"') && value.endsWith('"')) || (value.startsWith("'") && value.endsWith("'"))) {
				value = value.slice(1, -1);
			}

			if (currentSection !== null) {
				currentRecord[key] = value;
			}
		}
	}

	if (currentSection !== null) {
		map.set(currentSection, currentRecord);
	}

	return map;
}

// Load extra params once at startup
let modelParams = new Map<string, Record<string, unknown>>();
try {
	const configPath = path.join(process.env.HOME || "", ".pi", "agent", "models-extra-params.toml");
	const raw = fs.readFileSync(configPath, "utf-8");
	modelParams = parseParamsTOML(raw);
	console.log(`[llama-server-progress] loaded ${modelParams.size} model(s) from ${configPath}`);
} catch (err: any) {
	if (err.code !== "ENOENT") {
		console.error(`[llama-server-progress] failed to read extra params: ${err.message}`);
	}
}

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

interface PromptProgress {
	total: number;
	cache: number;
	processed: number;
	time_ms: number;
}

interface AssistantMessageWithProgress extends AssistantMessage {
	/** Attached during prompt-eval so the extension handler can read it. */
	promptProgress?: PromptProgress;
}

// ---------------------------------------------------------------------------
// SSE decoder (mirrors the anthropic provider helper)
// ---------------------------------------------------------------------------

interface ServerSentEvent {
	event: string | null;
	data: string;
	raw: string[];
}

interface SseDecoderState {
	event: string | null;
	data: string[];
	raw: string[];
}

function nextLineBreakIndex(text: string): number {
	const nl = text.indexOf("\n");
	const cr = text.indexOf("\r");
	if (cr === -1) return nl;
	if (nl === -1) return cr;
	return cr < nl ? cr : nl;
}

function consumeLine(text: string): { line: string; rest: string } | null {
	const idx = nextLineBreakIndex(text);
	if (idx === -1) return null;
	let next = idx + 1;
	if (text[idx] === "\r" && text[next] === "\n") next++;
	return { line: text.slice(0, idx), rest: text.slice(next) };
}

async function* iterateSseMessages(
	body: ReadableStream<Uint8Array>,
	signal?: AbortSignal,
): AsyncGenerator<ServerSentEvent> {
	const reader = body.getReader();
	const decoder = new TextDecoder();
	const state: SseDecoderState = { event: null, data: [], raw: [] };
	let buffer = "";

	try {
		while (true) {
			if (signal?.aborted) throw new Error("aborted");
			const { value, done } = await reader.read();
			if (done) break;
			buffer += decoder.decode(value, { stream: true });

			let consumed = consumeLine(buffer);
			while (consumed) {
				const { line, rest } = consumed;
				buffer = rest;
				state.raw.push(line);

				if (line === "") {
					if (state.data.length > 0) {
						yield {
							event: state.event,
							data: state.data.join("\n"),
							raw: [...state.raw],
						};
					}
					state.event = null;
					state.data = [];
					state.raw = [];
				} else if (line.startsWith("event:")) {
					state.event = line.slice(6).trimStart();
				} else if (line.startsWith("data:")) {
					state.data.push(line.slice(5).trimEnd());
				} else if (line.startsWith("id:")) {
					// ignore
				}
				consumed = consumeLine(buffer);
			}
		}
		// Flush remaining
		if (state.data.length > 0) {
			yield {
				event: state.event,
				data: state.data.join("\n"),
				raw: [...state.raw],
			};
		}
	} finally {
		reader.releaseLock();
	}
}

// ---------------------------------------------------------------------------
// Message conversion (openai-completions compat)
// ---------------------------------------------------------------------------

function convertMessages(
	messages: Message[],
	_compat: any,
): Array<{ role: string; content?: string | any[]; tool_calls?: any[]; tool_call_id?: string; name?: string }> {
	const out: any[] = [];
	for (let i = 0; i < messages.length; i++) {
		const msg = messages[i];
		if (msg.role === "user") {
			if (typeof msg.content === "string") {
				if (msg.content.trim()) out.push({ role: "user", content: msg.content });
			} else {
				const parts = msg.content.map((c) =>
					c.type === "text"
						? { type: "text", text: c.text }
						: {
								type: "image_url",
								image_url: {
									url: `data:${c.mimeType};base64,${c.data}`,
									detail: "auto",
								},
							},
				);
				out.push({ role: "user", content: parts });
			}
		} else if (msg.role === "assistant") {
			const assistantTextParts: string[] = [];
			const thinkingBlocks: Array<{ thinking: string; signature?: string }> = [];
			const toolCalls: any[] = [];
			for (const block of msg.content) {
				if (block.type === "text" && block.text.trim()) {
					assistantTextParts.push(block.text);
				} else if (block.type === "thinking") {
					thinkingBlocks.push({
						thinking: block.thinking,
						signature: (block as ThinkingContent).thinkingSignature,
					});
				} else if (block.type === "toolCall") {
					toolCalls.push({
						id: block.id,
						type: "function",
						function: {
							name: block.name,
							arguments: JSON.stringify(block.arguments),
						},
					});
				}
			}
			const entry: any = { role: "assistant" };
			const assistantText = assistantTextParts.join("");
			if (assistantText.length > 0) entry.content = assistantText;
			if (thinkingBlocks.length > 0) {
				// Replay prior reasoning on the same field name so qwen-chat-template
				// preserve_thinking can carry it across turns.
				const signature = thinkingBlocks[0].signature;
				if (signature && signature.length > 0) {
					entry[signature] = thinkingBlocks.map((block) => block.thinking).join("\n");
				}
			}
			if (toolCalls.length > 0) entry.tool_calls = toolCalls;
			// Some servers need content even when there are tool calls
			if (toolCalls.length > 0 && !entry.content) entry.content = "";
			out.push(entry);
		} else if (msg.role === "toolResult") {
			const content = typeof msg.content === "string" ? msg.content : msg.content.map((c) => c.text).join("\n");
			out.push({
				role: "tool",
				content,
				tool_call_id: msg.toolCallId,
			});
		}
	}
	return out;
}

function convertTools(tools: Tool[]): any[] {
	return tools.map((tool) => ({
		type: "function",
		function: {
			name: tool.name,
			description: tool.description,
			parameters: (tool.parameters as any) || {
				type: "object",
				properties: {},
			},
		},
	}));
}

// ---------------------------------------------------------------------------
// Stop-reason mapping
// ---------------------------------------------------------------------------

function mapStopReason(finish: string | null | undefined): StopReason {
	switch (finish) {
		case "stop":
		case "stop_sequence":
			return "stop";
		case "length":
			return "length";
		case "tool_calls":
		case "tool_use":
			return "toolUse";
		case "abort":
			return "aborted";
		default:
			return "stop";
	}
}

// ---------------------------------------------------------------------------
// Stream function
// ---------------------------------------------------------------------------

function streamLlamaServer(
	model: Model<Api>,
	context: Context,
	options?: SimpleStreamOptions,
): AssistantMessageEventStream {
	const stream = createAssistantMessageEventStream();

	(async () => {
		const output: AssistantMessageWithProgress = {
			role: "assistant",
			content: [],
			api: model.api as Api,
			provider: model.provider,
			model: model.id,
			usage: {
				input: 0,
				output: 0,
				cacheRead: 0,
				cacheWrite: 0,
				totalTokens: 0,
				cost: { input: 0, output: 0, cacheRead: 0, cacheWrite: 0, total: 0 },
			},
			stopReason: "stop",
			timestamp: Date.now(),
		};

		try {
			const apiKey = options?.apiKey;
			if (!apiKey) throw new Error(`No API key for provider: ${model.provider}`);

			// -- Build request body ------------------------------------------------
			const body: Record<string, unknown> = {
				model: model.id,
				messages: convertMessages(context.messages, model.compat),
				stream: true,
				return_progress: true,
			};

			// max_tokens / max_completion_tokens
			const maxField = model.compat?.maxTokensField === "max_tokens" ? "max_tokens" : "max_completion_tokens";
			if (options?.maxTokens) body[maxField] = options.maxTokens;
			else if (model.maxTokens) body[maxField] = model.maxTokens;

			// temperature
			if (options?.temperature !== undefined) body.temperature = options.temperature;

			// extra params from models-extra-params.toml
			const extra = modelParams.get(model.id);
			if (extra) {
				// Apply extra params, but don't override values already set
				for (const [key, value] of Object.entries(extra)) {
					if (!(key in body)) {
						body[key] = value;
					}
				}
			}

			// tools
			if (context.tools && context.tools.length > 0) {
				body.tools = convertTools(context.tools);
			}

			// system prompt
			if (context.systemPrompt) {
				// Prepend system as a message if not already handled
				// (convertMessages already handles it via context.messages)
			}

			// thinking / reasoning (qwen-chat-template for llama.cpp)
			const thinkingFormat = model.compat?.thinkingFormat;
			if (options?.reasoning && model.reasoning) {
				if (thinkingFormat === "qwen-chat-template") {
					body.chat_template_kwargs = {
						enable_thinking: true,
						preserve_thinking: true,
					};
				} else if (thinkingFormat === "qwen") {
					body.enable_thinking = true;
				}
				// reasoning_effort for openai-style
				if (model.compat?.supportsReasoningEffort) {
					body.reasoning_effort =
						model.thinkingLevelMap?.[options.reasoning] ?? options.reasoning;
				}
			} else if (options?.reasoning === "off" && model.reasoning && model.compat?.supportsReasoningEffort) {
				const offVal = model.thinkingLevelMap?.off;
				if (typeof offVal === "string") body.reasoning_effort = offVal;
			}

			// stream_options for usage
			if (model.compat?.supportsUsageInStreaming !== false) {
				body.stream_options = { include_usage: true };
			}

			// -- Fetch ------------------------------------------------------------
			const url = `${model.baseUrl}/chat/completions`;
			const headers: Record<string, string> = {
				"Content-Type": "application/json",
				Authorization: `Bearer ${apiKey}`,
				...(model.headers ?? {}),
			};
			if (options?.headers) Object.assign(headers, options.headers);

			const response = await fetch(url, {
				method: "POST",
				headers,
				body: JSON.stringify(body),
				signal: options?.signal,
			});

			if (!response.ok) {
				const errText = await response.text().catch(() => "");
				throw new Error(
					`llama-server HTTP ${response.status}: ${errText.slice(0, 500)}`,
				);
			}

			if (!response.body) throw new Error("No response body");

			// -- SSE parsing ------------------------------------------------------
			stream.push({ type: "start", partial: output });

			interface StreamingToolCallBlock extends ToolCall {
				partialArgs?: string;
				streamIndex?: number;
			}
			type StreamingBlock = TextContent | ThinkingContent | StreamingToolCallBlock;
			const blocks = output.content as StreamingBlock[];

			let textBlock: TextContent | null = null;
			let thinkingBlock: ThinkingContent | null = null;
			let hasFinishReason = false;
			const toolCallBlocksByIndex = new Map<number, StreamingToolCallBlock>();
			const toolCallBlocksById = new Map<string, StreamingToolCallBlock>();

			const ensureTextBlock = () => {
				if (!textBlock) {
					textBlock = { type: "text", text: "" };
					blocks.push(textBlock);
					stream.push({ type: "text_start", contentIndex: blocks.length - 1, partial: output });
				}
				return textBlock;
			};

			const ensureThinkingBlock = (sig: string) => {
				if (!thinkingBlock) {
					thinkingBlock = { type: "thinking", thinking: "", thinkingSignature: sig };
					blocks.push(thinkingBlock);
					stream.push({ type: "thinking_start", contentIndex: blocks.length - 1, partial: output });
				}
				return thinkingBlock;
			};

			const ensureToolCallBlock = (tc: any) => {
				const idx = typeof tc.index === "number" ? tc.index : undefined;
				let block = idx !== undefined ? toolCallBlocksByIndex.get(idx) : undefined;
				if (!block && tc.id) block = toolCallBlocksById.get(tc.id);
				if (!block) {
					block = {
						type: "toolCall",
						id: tc.id || "",
						name: tc.function?.name || "",
						arguments: {},
						partialArgs: "",
						streamIndex: idx,
					};
					if (idx !== undefined) toolCallBlocksByIndex.set(idx, block);
					if (tc.id) toolCallBlocksById.set(tc.id, block);
					blocks.push(block);
					stream.push({ type: "toolcall_start", contentIndex: blocks.length - 1, partial: output });
				}
				return block;
			};

			const finishBlock = (block: StreamingBlock) => {
				const ci = blocks.indexOf(block);
				if (ci === -1) return;
				if (block.type === "text") {
					stream.push({ type: "text_end", contentIndex: ci, content: block.text, partial: output });
				} else if (block.type === "thinking") {
					stream.push({ type: "thinking_end", contentIndex: ci, content: block.thinking, partial: output });
				} else if (block.type === "toolCall") {
					try {
						block.arguments = JSON.parse(block.partialArgs || "{}");
					} catch {
						block.arguments = {};
					}
					delete block.partialArgs;
					delete block.streamIndex;
					stream.push({ type: "toolcall_end", contentIndex: ci, toolCall: block as ToolCall, partial: output });
				}
			};

			for await (const sse of iterateSseMessages(response.body, options?.signal)) {
				if (sse.data === "[DONE]") continue;
				let parsed: Record<string, unknown>;
				try {
					parsed = JSON.parse(sse.data);
				} catch {
					continue;
				}

				// -- prompt_progress (llama-server extension) ----------------
				const choices = Array.isArray(parsed.choices) ? parsed.choices : [];

				if (parsed.prompt_progress && !choices.length) {
					output.promptProgress = parsed.prompt_progress as PromptProgress;
					// Emit a `start` event carrying the progress so the extension
					// message_update handler can pick it up and call setWorkingMessage.
					stream.push({ type: "start", partial: output });
					continue;
				}

				// Prompt evaluation is done once we see a real completion chunk.
				// Clear progress so the working message is no longer overwritten
				// and pi can show its normal "Thinking", "Replying", etc. statuses.
				if (output.promptProgress && (choices.length > 0 || !parsed.prompt_progress)) {
					delete output.promptProgress;
				}

				// -- Standard openai-completions chunk -----------------------

				// Usage — can arrive in a chunk without choices, so process it
				// before the `if (!choice) continue` guard.
				// Matches parseChunkUsage from openai-completions provider:
				//   input = prompt_tokens - cache_read - cache_write
				if (parsed.usage) {
					const u = parsed.usage as Record<string, number>;
					const promptTokens = u.prompt_tokens ?? 0;
					const cacheReadTokens = u.cache_read_tokens ?? 0;
					const cacheWriteTokens = u.cache_write_tokens ?? 0;
					output.usage.input = Math.max(0, promptTokens - cacheReadTokens - cacheWriteTokens);
					output.usage.output = u.completion_tokens ?? output.usage.output;
					output.usage.cacheRead = cacheReadTokens;
					output.usage.cacheWrite = cacheWriteTokens;
					output.usage.totalTokens =
						output.usage.input + output.usage.output + cacheReadTokens + cacheWriteTokens;
				}

				const choice = choices[0];
				if (!choice) continue;

				// Fallback: some providers return usage in choice.usage
				if ((choice as any).usage) {
					const u = (choice as any).usage as Record<string, number>;
					const promptTokens = u.prompt_tokens ?? 0;
					const cacheReadTokens = u.cache_read_tokens ?? 0;
					const cacheWriteTokens = u.cache_write_tokens ?? 0;
					output.usage.input = Math.max(0, promptTokens - cacheReadTokens - cacheWriteTokens);
					output.usage.output = u.completion_tokens ?? output.usage.output;
					output.usage.cacheRead = cacheReadTokens;
					output.usage.cacheWrite = cacheWriteTokens;
					output.usage.totalTokens =
						output.usage.input + output.usage.output + cacheReadTokens + cacheWriteTokens;
				}

				if (choice.finish_reason) {
					output.stopReason = mapStopReason(choice.finish_reason);
					hasFinishReason = true;
				}

				const delta = choice.delta as Record<string, unknown> | undefined;
				if (!delta) continue;

				// role delta (first chunk) — ignore
				if (delta.role && !delta.content && !delta.reasoning_content) continue;

				// Text content
				if (typeof delta.content === "string" && delta.content.length > 0) {
					const block = ensureTextBlock();
					block.text += delta.content;
					stream.push({
						type: "text_delta",
						contentIndex: blocks.indexOf(block),
						delta: delta.content,
						partial: output,
					});
				}

				// Reasoning content (llama.cpp uses reasoning_content)
				const reasoningFields = ["reasoning_content", "reasoning", "reasoning_text"];
				let foundReasoning: string | null = null;
				for (const field of reasoningFields) {
					const val = delta[field];
					if (typeof val === "string" && val.length > 0) {
						foundReasoning = field;
						break;
					}
				}
				if (foundReasoning) {
					const val = delta[foundReasoning] as string;
					const block = ensureThinkingBlock(foundReasoning);
					block.thinking += val;
					stream.push({
						type: "thinking_delta",
						contentIndex: blocks.indexOf(block),
						delta: val,
						partial: output,
					});
				}

				// Tool calls
				if (Array.isArray(delta.tool_calls)) {
					for (const tc of delta.tool_calls) {
						const block = ensureToolCallBlock(tc);
						if (!block.id && tc.id) {
							block.id = tc.id;
							toolCallBlocksById.set(tc.id, block);
						}
						if (!block.name && tc.function?.name) block.name = tc.function.name;
						if (tc.function?.arguments) {
							block.partialArgs = (block.partialArgs || "") + tc.function.arguments;
							try {
								block.arguments = JSON.parse(block.partialArgs);
							} catch {
								// partial JSON, will parse later
							}
							stream.push({
								type: "toolcall_delta",
								contentIndex: blocks.indexOf(block),
								delta: tc.function.arguments,
								partial: output,
							});
						}
					}
				}
			}

			// Finish all open blocks
			for (const block of blocks) finishBlock(block);

			if (options?.signal?.aborted) throw new Error("aborted");
			if (output.stopReason === "aborted") throw new Error("aborted");
			if (output.stopReason === "error") throw new Error(output.errorMessage || "error stop reason");
			if (!hasFinishReason) throw new Error("Stream ended without finish_reason");

			// Clear progress before done
			delete output.promptProgress;

			stream.push({
				type: "done",
				reason: output.stopReason as "stop" | "length" | "toolUse",
				message: output as AssistantMessage,
			});
			stream.end();
		} catch (error) {
			output.stopReason = options?.signal?.aborted ? "aborted" : "error";
			output.errorMessage = error instanceof Error ? error.message : String(error);
			delete output.promptProgress;
			stream.push({ type: "error", reason: output.stopReason, error: output as AssistantMessage });
			stream.end();
		}
	})();

	return stream;
}

// ---------------------------------------------------------------------------
// Extension entry point
// ---------------------------------------------------------------------------

export default function (pi: ExtensionAPI) {
	// Register the provider with custom streamSimple.
	// Models are loaded from models.json (or can be overridden here).
	pi.registerProvider("llama-server", {
		api: "llama-server-progress",
		streamSimple: streamLlamaServer,
	});

	// Hook message_update to drive the working-message loader with progress.
	pi.on("message_update", async (event, ctx) => {
		const progress = (event.message as AssistantMessageWithProgress).promptProgress;
		if (!progress || progress.total <= 0) return;

		const pct = Math.round((progress.processed / progress.total) * 100);
		const cached = progress.cache > 0 ? ` (${progress.cache} cached)` : "";
		const elapsed = progress.time_ms > 0 ? ` ${progress.time_ms}ms` : "";
		ctx.ui.setWorkingMessage(`Evaluating prompt… ${pct}%${cached}${elapsed}`);
	});
}
