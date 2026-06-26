import type { SubAgentConfig } from "./sub-agent";

export const researchConfig: SubAgentConfig = {
	name: "research",
	label: "Research",
	description:
		"Delegate a research task to a sub-agent with an isolated context window. " +
		"The sub-agent can read files and run commands but cannot edit or write. " +
		"Use this for: tracing code flows, finding usages, exploring unfamiliar code, " +
		"answering questions that require reading many files. " +
		"Provide a detailed prompt describing exactly what to find.",
	tools: ["read", "bash", "grep", "find", "ls"],
};
