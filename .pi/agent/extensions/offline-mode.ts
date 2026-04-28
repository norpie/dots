/**
 * offline-mode.ts — Toggle network-isolated "offline mode" for pi.
 *
 * Every bash command runs inside `sudo unshare --net`, which creates a
 * network namespace with zero external interfaces. Loopback (localhost)
 * is restored so local services still work.
 *
 * Requires passwordless sudo (works for you — verified).
 *
 * Usage:
 *   /offline           Enable offline mode
 *   /online            Disable offline mode
 *   Ctrl+Shift+O       Quick toggle
 *
 * Place in ~/.pi/agent/extensions/ or .pi/extensions/ for auto-discovery.
 */
import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { isToolCallEventType } from "@mariozechner/pi-coding-agent";

const STATE_KEY = "offline-mode-state";
const STATUS_ID = "offline-mode";

/**
 * Wrap a bash command inside a network-isolated namespace.
 *
 * `sudo unshare --net` creates a fresh network namespace with no interfaces.
 * We bring loopback up so localhost still works, then exec the original command.
 */
function wrapOffline(command: string): string {
  // Escape single quotes for bash -c '...' context
  const escaped = command.replace(/'/g, "'\\''");
  return `sudo unshare --net bash -c "ip link set lo up 2>/dev/null; exec bash -c '${escaped}'"`;
}

export default function (pi: ExtensionAPI) {
  let offline = false;

  // Restore persisted state on session start
  pi.on("session_start", async (_event, ctx) => {
    for (const entry of ctx.sessionManager.getEntries()) {
      if (entry.type === "custom" && entry.customType === STATE_KEY && entry.data?.offline) {
        offline = true;
        ctx.ui.setStatus(STATUS_ID, "⛓ Offline Mode");
        break;
      }
    }
  });

  // Intercept every bash tool call
  pi.on("tool_call", async (event, _ctx) => {
    if (!offline) return;
    if (isToolCallEventType("bash", event)) {
      event.input.command = wrapOffline(event.input.command);
    }
  });

  // Register /offline command
  pi.registerCommand("offline", {
    description: "Enable offline mode (block all internet access)",
    handler: async (_args, ctx) => {
      offline = true;
      pi.appendEntry(STATE_KEY, { offline: true });
      ctx.ui.setStatus(STATUS_ID, "⛓ Offline Mode");
      ctx.ui.notify("Offline mode enabled — internet access blocked", "info");
    },
  });

  // Register /online command
  pi.registerCommand("online", {
    description: "Disable offline mode (restore internet access)",
    handler: async (_args, ctx) => {
      offline = false;
      pi.appendEntry(STATE_KEY, { offline: false });
      ctx.ui.setStatus(STATUS_ID, "");
      ctx.ui.notify("Online mode restored", "success");
    },
  });

  // Shortcut: Ctrl+Shift+O to toggle
  pi.registerShortcut("ctrl+shift+o", {
    description: "Toggle offline mode",
    handler: async (ctx) => {
      offline = !offline;
      pi.appendEntry(STATE_KEY, { offline });
      if (offline) {
        ctx.ui.setStatus(STATUS_ID, "⛓ Offline Mode");
        ctx.ui.notify("Offline mode enabled", "info");
      } else {
        ctx.ui.setStatus(STATUS_ID, "");
        ctx.ui.notify("Online mode restored", "success");
      }
    },
  });
}