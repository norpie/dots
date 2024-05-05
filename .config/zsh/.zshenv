if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
    which Hyprland &> /dev/null
    [[ $? -eq 0 ]] && exec Hyprland && exit
fi
