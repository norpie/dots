function append_path() {
    export PATH="$PATH:$1"
}

# on init set HISTFILE to $HOME/.cache/zsh/history
# or null if we are in /mnt
if [[ $PWD == /mnt* ]]; then
    export HISTFILE=/dev/null
else
    export HISTFILE=$HOME/.cache/zsh/history
fi

# cd with history, based on minecraft essentials /back
function cd() {
    # Stop recording history if we cd into /mnt or move around in /mnt
    if [[ $1 == /mnt* || $PWD == /mnt* ]]; then
        [[ ! $HISTFILE == /dev/null ]] && export HISTFILE=/dev/null && echo "History disabled" && sed -i '$ d' $HOME/.cache/zsh/history
    else
        [[ $HISTFILE == /dev/null ]] && export HISTFILE=$HOME/.cache/zsh/history && echo "History enabled"
    fi
    # If no arguments, and in `git dir` and not in `git root`, cd to `git root`
    if [[ $# == 0 ]]; then
        GIT_ROOT=$(project subroot)
        if [[ $GIT_ROOT != "" && $GIT_ROOT == $PWD ]]; then
            builtin cd
        else
            builtin cd $GIT_ROOT
        fi
        return
    fi
    z $@
}

function back() {
    cd -
}

function yazi() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    command yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

function telescope() {
    file=$(find | fzf --preview 'if [[ -d {} ]]; then; ls {}; else; pygmentize -g {}; fi;')
    [[ -d $file ]] && cd $file
    [[ -f $file ]] && $EDITOR $file
}

function config() {
    [[ $# == 1 && $1 == "cs" ]] &&
        $EDITOR "$HOME/.local/share/Steam/steamapps/common/Counter-Strike Global Offensive/game/csgo/cfg/autoexec.cfg" &&
        return    
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
        [ ! -f $SCRIPT_PATH ] && echo '#!/usr/bin/env bash' > $SCRIPT_PATH && chmod +x $SCRIPT_PATH
        $EDITOR $SCRIPT_PATH
    fi
}
