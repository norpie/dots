import type { SubAgentConfig } from "./sub-agent";

export const websearchConfig: SubAgentConfig = {
	name: "websearch",
	label: "Web Search",
	description:
		"Delegate a web research task to a sub-agent with web navigation capabilities. " +
		"The sub-agent can search the web and fetch page content but cannot edit files. " +
		"Use this for: looking up documentation, finding information online, researching topics, " +
		"checking current status of projects or services. " +
		"Provide a detailed prompt describing what to find.",
	tools: ["bash"],
	systemPrompt: `You are a web research agent. You have two tools for web navigation:

- compendium-app search <QUERY> — search the web (use -n to control result count, default is fine)
- compendium-app fetch <URL> — fetch and extract readable content from a URL

Strategy:
1. If the user's prompt includes a specific URL, fetch it directly with compendium-app fetch.
2. If the prompt is a general question or topic, first run compendium-app search with a focused query, then fetch the most relevant URLs from the results to gather detailed information.
3. Read and synthesize the fetched content. If needed, fetch additional pages to fill gaps.
4. Provide a clear, well-structured answer summarising your findings with key details.`,
};
