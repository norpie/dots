# Fzf script for repos directory
function project() {
    dir=$(find $REPO_DIRECTORY -maxdepth 1 | fzf) && cd $dir
}

# cd with history, based on minecraft /back
function cd() {
    export LAST_DIR=$(pwd)
    builtin cd $@
}
function back() {
    cd $LAST_DIR
}

# Fzf config editor script
function config() {
    file=$(find $XDG_CONFIG_HOME -maxdepth 3 | fzf --preview 'pygmentize {}')
    [[ -d $file ]] && cd $file
    [[ -f $file ]] && $EDITOR $file
}

function script() {
    if [[ $# == 0 ]]; then
        file=$(find $SCRIPT_DIR | fzf) 
        [[ -d $file ]] && cd $file
        [[ -f $file ]] && $EDITOR $file
    else 
        SCRIPT_PATH="$HOME/.local/bin/$1"
        [ ! -f $SCRIPT_PATH ] && echo '#!/bin/zsh' > $SCRIPT_PATH && chmod +x $SCRIPT_PATH 
        $EDITOR $SCRIPT_PATH
    fi 
}

function template() {
    file=$(find $XDG_DATA_HOME/templates -maxdepth 1 | fzf --preview 'pygmentize {}')
    [[ -d $file ]] && cd $file
    [[ -f $file ]] && cp $file .
}
