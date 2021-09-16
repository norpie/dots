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
