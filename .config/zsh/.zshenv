export ZDOTDIR="/home/$USER/.config/zsh"

if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
    source "$ZDOTDIR/environment.zsh"
    [[ -f /home/$USER/.xinitrc ]] && exec startx
fi
