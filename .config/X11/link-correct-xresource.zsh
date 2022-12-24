#!/bin/zsh

cd "$XDG_CONFIG_HOME/X11"
if [[ -f "Xresources-$HOST" ]]; then
    ln -sf "Xresources-$HOST" "Xresources"
else
    ln -sf "Xresources-desktop" "Xresources"
fi
