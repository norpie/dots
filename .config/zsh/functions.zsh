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

source $ZDOTDIR/functions/config.zsh
source $ZDOTDIR/functions/script.zsh
source $ZDOTDIR/functions/template.zsh
