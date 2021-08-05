export ZDOTDIR="/home/$USER/.config/zsh"

source "$ZDOTDIR/environment.zsh"

if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then 
    exec startx
fi
