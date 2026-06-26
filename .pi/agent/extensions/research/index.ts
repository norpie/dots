import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { createSubAgentTool } from "./sub-agent";
import { researchConfig } from "./research";
import { websearchConfig } from "./websearch";

const SUB_AGENTS = [
	researchConfig,
	websearchConfig,
];

export default function (pi: ExtensionAPI) {
	for (const config of SUB_AGENTS) {
		pi.registerTool(createSubAgentTool(config));
	}
}
