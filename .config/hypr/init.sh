#!/usr/bin/env zsh

source ~/.config/zsh/.zshrc

# Cache Wayland display for scripts (equivalent to X11's DISPLAY cache)
echo $WAYLAND_DISPLAY > ~/.cache/wayland_display

# Cache Hyprland instance signature for hyprctl commands
echo $HYPRLAND_INSTANCE_SIGNATURE > ~/.cache/hyprland_instance

ssh-add ~/.config/ssh/identities/norpie
monitor layout default
wallpaper --default

# Hyprland-specific startup tasks
# (Add any Wayland/Hyprland equivalents of xorg-state-load, etc. here)