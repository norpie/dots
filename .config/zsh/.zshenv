if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
    date >> /tmp/zsh.debug
    exec >> /tmp/zsh.debug
    exec 2>&1
    set -x
    source "$ZDOTDIR/environment.zsh"
    [[ -f /home/norpie/.xinitrc ]] && exec startx
fi
