#!/bin/zsh

source ~/.config/zsh/.zshrc

numlockx on
xresources-reload
xwallpaper --zoom ~/.config/wallpaper/wallpaper.png
xroot-status-restart
restart output-fixer
sleep 5 && xset s off && xset -dpms
escapecaps
xorg-state-load
