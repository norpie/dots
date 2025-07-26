#!/usr/bin/env zsh

echo "Init script starting" >> /tmp/hypr-init.log

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