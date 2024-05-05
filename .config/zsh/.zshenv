if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
    which Hyprland
    [[ $? -eq 0 ]] && exec Hyprland && exit
    which startx
    [[ $? -eq 0 ]] && [[ -f /home/norpie/.xinitrc ]] && exec startx && exit
fi
