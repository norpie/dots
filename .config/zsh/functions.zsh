# Fzf script for repos directory
function repos() {
    dir=$(find $REPO_DIR -maxdepth 1 | fzf) && cd $dir
}

function append_path() {
    export PATH="$PATH:$1"
}

# cd with history, based on minecraft /back, and also fetch on repo enter
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

function template() {
    file=$(find $XDG_DATA_HOME/templates -maxdepth 1 | fzf --preview 'pygmentize {}')
    [[ -d $file ]] && cd $file
    [[ -f $file ]] && clear && echo "Enter a filename: " && read filename && cp $file $filename
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

function workspace() {
    file=$(find $(dirname $(cargo locate-project --workspace | jq -r .root)) -maxdepth 1 -type d -not -path '*/.*' ! -name "target" | fzf --preview 'ls {}')
    [[ "$file" != "" ]] && cd $file && cd src >/dev/null 2>&1
}
