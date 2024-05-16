function append_path() {
    export PATH="$PATH:$1"
}

# cd with history, based on minecraft essentials /back
function cd() {
    export LAST_DIR=$(pwd)
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
