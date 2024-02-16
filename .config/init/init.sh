#!/bin/zsh

source ~/.config/zsh/.zshrc

ssh-add-defaults
numlockx on
xroot-status-restart
xorg-state-load
restart timed-fixer
sleep 1 && xwallpaper --zoom ~/.config/wallpapers/wallpaper.png
# arch-freeze-kernel-modules
