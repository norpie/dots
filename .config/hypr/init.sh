#!/usr/bin/env zsh

echo "Init script starting" >> /tmp/hypr-init.log

# Java applications compatibility
export _JAVA_AWT_WM_NONREPARENTING=1
echo "Exported Java compatibility variable" >> /tmp/hypr-init.log

# Update dbus activation environment
dbus-update-activation-environment --all
echo "Updated dbus activation environment" >> /tmp/hypr-init.log

# Start ssh-agent and cache variables
eval $(ssh-agent -s)
echo $SSH_AUTH_SOCK > ~/.cache/ssh_auth_sock
echo $SSH_AGENT_PID > ~/.cache/ssh_agent_pid
echo "Started ssh-agent and cached variables" >> /tmp/hypr-init.log

source ~/.config/zsh/.zshrc
echo "Sourced zshrc" >> /tmp/hypr-init.log

# Cache Wayland display for scripts (equivalent to X11's DISPLAY cache)
echo $WAYLAND_DISPLAY > ~/.cache/wayland_display
echo "Cached WAYLAND_DISPLAY: $WAYLAND_DISPLAY" >> /tmp/hypr-init.log

# Cache Hyprland instance signature for hyprctl commands
echo $HYPRLAND_INSTANCE_SIGNATURE > ~/.cache/hyprland_instance
echo "Cached HYPRLAND_INSTANCE_SIGNATURE: $HYPRLAND_INSTANCE_SIGNATURE" >> /tmp/hypr-init.log

echo "About to run monitor layout default" >> /tmp/hypr-init.log
monitor layout default
echo "Finished monitor layout default" >> /tmp/hypr-init.log

echo "Init script completed" >> /tmp/hypr-init.log