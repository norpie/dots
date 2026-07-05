import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { createBashTool, createGrepTool, createReadTool } from "@earendil-works/pi-coding-agent";

function normalizePath(input: string): string {
	return input.replace(/\\/g, "/");
}

function basename(input: string): string {
	const normalized = normalizePath(input).replace(/\/+$|^\s+|\s+$/g, "");
	const parts = normalized.split("/").filter(Boolean);
	return parts.length ? parts[parts.length - 1] : normalized;
}

function isDotEnvFile(path: string): boolean {
	const base = basename(path);
	return base === ".env" || base.startsWith(".env.");
}

function looksLikeEnvReadCommand(command: string): boolean {
	const normalized = command.replace(/\s+/g, " ").trim();
	if (!normalized.includes(".env")) return false;

	// Common file-reading / file-searching commands that could expose .env contents.
	const readerPattern = /\b(cat|grep|rg|ack|ag|sed|awk|less|more|head|tail|bat|nl|tac|xargs)\b/i;
	const redirectionPattern = /(^|[^<])<\s*[^\s;|&(){}]*\.env(?:\.[^\s;|&(){}]+)?/i;
	const envPathPattern = /(^|[\s'"`(])(?:\.\/|\.\.\/|~\/|\/)?(?:[^\s'"`()/]+\/)*\.env(?:\.[^\s'"`()/]+)?([\s'"`)]|$)/i;

	return readerPattern.test(normalized) || redirectionPattern.test(normalized) || envPathPattern.test(normalized);
}

function denyMessage(target: string): string {
	return `Access denied: reading "${target}" is blocked by env-guard.`;
}

export default function (pi: ExtensionAPI) {
	const toolCache = new Map<string, { read: ReturnType<typeof createReadTool>; grep: ReturnType<typeof createGrepTool>; bash: ReturnType<typeof createBashTool> }>();

	function getTools(cwd: string) {
		let tools = toolCache.get(cwd);
		if (!tools) {
			tools = {
				read: createReadTool(cwd),
				grep: createGrepTool(cwd),
				bash: createBashTool(cwd),
			};
			toolCache.set(cwd, tools);
		}

		return tools;
	}

	const builtIn = getTools(process.cwd());

	pi.registerTool({
		...builtIn.read,
		async execute(toolCallId, params, signal, onUpdate, ctx) {
			if (isDotEnvFile(params.path)) {
				return {
					content: [{ type: "text", text: denyMessage(params.path) }],
					details: { blocked: true },
				};
			}

			return getTools(ctx.cwd).read.execute(toolCallId, params, signal, onUpdate, ctx);
		},
	});

	pi.registerTool({
		...builtIn.grep,
		async execute(toolCallId, params, signal, onUpdate, ctx) {
			const targetPath = params.path ?? "";
			const searchTarget = `${params.pattern} ${targetPath} ${params.glob ?? ""}`;
			if (isDotEnvFile(targetPath) || searchTarget.includes(".env")) {
				return {
					content: [{ type: "text", text: denyMessage(targetPath || params.pattern) }],
					details: { blocked: true },
				};
			}

			return getTools(ctx.cwd).grep.execute(toolCallId, params, signal, onUpdate, ctx);
		},
	});

	pi.registerTool({
		...builtIn.bash,
		async execute(toolCallId, params, signal, onUpdate, ctx) {
			if (looksLikeEnvReadCommand(params.command)) {
				return {
					content: [{ type: "text", text: `Access denied: shell access to .env is blocked by env-guard.` }],
					details: { blocked: true },
				};
			}

			return getTools(ctx.cwd).bash.execute(toolCallId, params, signal, onUpdate, ctx);
		},
	});
}
