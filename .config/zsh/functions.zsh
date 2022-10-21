# Fzf script for repos directory
function project() {
    dir=$(find $REPO_DIR -maxdepth 1 | fzf) && cd $dir
}

# cd with history, based on minecraft /back, and also fetch on repo enter
LAST_REPO=""

function cd() {
    export LAST_DIR=$(pwd)
    builtin cd "$@"
    git rev-parse 2>/dev/null

    if [ $? -eq 0 ]; then
        if [ "$LAST_REPO" != $(basename $(git rev-parse --show-toplevel)) ]; then
            onefetch
            LAST_REPO=$(basename $(git rev-parse --show-toplevel))
        fi
    fi
}

function back() {
    cd $LAST_DIR
}

function telescope() {
    file=$(find | fzf --preview 'pygmentize {}')
    [[ -d $file ]] && cd $file
    [[ -f $file ]] && $EDITOR $file
}

function template() {
    file=$(find $XDG_DATA_HOME/templates -maxdepth 1 | fzf --preview 'pygmentize {}')
    [[ -d $file ]] && cd $file
    [[ -f $file ]] && clear && echo "Enter a filename: " && read filename && cp $file $filename
}

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

function workspace() {
    cd $WORKSPACE
}
