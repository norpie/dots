export ZDOTDIR="/home/norpie/.config/zsh"

if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
    source "$ZDOTDIR/environment.zsh"
    [[ -f /home/norpie/.xinitrc ]] && exec startx
fi
