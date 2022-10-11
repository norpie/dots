#!/bin/zsh

source ~/.config/zsh/.zshrc

xorg-state-load
numlockx on
xresources-reload
xroot-status-restart
restart output-fixer
sleep 5 && xset s off && xset -dpms
escapecaps
xwallpaper --zoom ~/.config/wallpapers/wallpaper.png
