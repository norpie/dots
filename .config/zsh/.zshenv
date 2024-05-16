if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
    which Hyprland && exec Hyprland
fi
