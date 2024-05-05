if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
    [[ $(which Hyprland) -eq 0 ]] && exec Hyprland && exit
    [[ -f /home/norpie/.xinitrc ]] && exec startx && exit
fi
