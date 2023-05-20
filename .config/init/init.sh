#!/bin/zsh

source ~/.config/zsh/.zshrc

ssh-add-defaults
numlockx on
xroot-status-restart
xorg-state-load
start timed-fixer
sleep 1 && xwallpaper --zoom ~/.config/wallpapers/wallpaper.png
