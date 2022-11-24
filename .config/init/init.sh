#!/bin/zsh

source ~/.config/zsh/.zshrc

xorg-state-load
numlockx on
xroot-status-restart
start output-fixer
escapecaps
xwallpaper --zoom ~/.config/wallpapers/wallpaper.png
sleep 5 && xset s off && xset -dpms
