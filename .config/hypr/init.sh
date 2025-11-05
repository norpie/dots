#!/usr/bin/env bash

# Java applications compatibility
export _JAVA_AWT_WM_NONREPARENTING=1

# Update dbus activation environment
dbus-update-activation-environment --all

# Start ssh-agent and cache variables
mkdir -p ~/.cache
eval $(ssh-agent -s)
ssh-add-defaults
echo $SSH_AUTH_SOCK > ~/.cache/ssh_auth_sock
echo $SSH_AGENT_PID > ~/.cache/ssh_agent_pid

# Ensure PATH includes .local/bin for reload command
export PATH="$HOME/.local/bin:$PATH"

# Cache Wayland display for scripts (equivalent to X11's DISPLAY cache)
echo $WAYLAND_DISPLAY > ~/.cache/wayland_display

# Cache Hyprland instance signature for hyprctl commands
echo $HYPRLAND_INSTANCE_SIGNATURE > ~/.cache/hyprland_instance

# Restore wallpaper from cache
wallpaper --restore
