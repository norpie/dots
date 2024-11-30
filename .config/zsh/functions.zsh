function append_path() {
    export PATH="$PATH:$1"
}

# cd with history, based on minecraft essentials /back
function cd() {
    export LAST_DIR=$(pwd)
    # Stop recording history if we cd into /mnt or move around in /mnt
    if [[ $1 == /mnt* || $PWD == /mnt* ]]; then
        [[ ! $HISTFILE == /dev/null ]] && export HISTFILE=/dev/null && echo "History disabled" && sed -i '$ d' $HOME/.cache/zsh/history
    else
        [[ $HISTFILE == /dev/null ]] && export HISTFILE=$HOME/.cache/zsh/history && echo "History enabled"
    fi
    builtin cd "$@"
}

function back() {
    cd $LAST_DIR
}

function telescope() {
    file=$(find | fzf --preview 'if [[ -d {} ]]; then; ls {}; else; pygmentize -g {}; fi;')
    [[ -d $file ]] && cd $file
    [[ -f $file ]] && $EDITOR $file
}

function config() {
    file=$(find $XDG_CONFIG_HOME -maxdepth 5 | fzf --preview 'if [[ -d {} ]]; then; ls {}; else; pygmentize -g {}; fi;')
    [[ -d $file ]] && cd $file
    [[ -f $file ]] && $EDITOR $file
}

function script() {
    if [[ $# == 0 ]]; then
        file=$(find $SCRIPT_DIR | fzf)
        [[ -d $file ]] && cd $file
        [[ -f $file ]] && $EDITOR $file
    else
        SCRIPT_PATH="/home/norpie/.local/bin/$1"
        [ ! -f $SCRIPT_PATH ] && echo '#!/usr/bin/env zsh' > $SCRIPT_PATH && chmod +x $SCRIPT_PATH
        $EDITOR $SCRIPT_PATH
    fi
}
