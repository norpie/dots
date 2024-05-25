#!/usr/bin/env zsh

source ~/.config/zsh/.zshrc

echo $DISPLAY > ~/.cache/display

ssh-add ~/.config/ssh/identities/norpie
xroot-status-restart
xorg-state-load
restart timed-fixer
wallpaper --default
tmux new-session -A -s default
numlockx on

# Delete stupid x files
files_to_remove=(
  ~/.xsession-errors
  ~/.compose-cache/
)

for file in $files_to_remove; do
  rm -rf $file
done
