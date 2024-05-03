eval `ssh-agent` &>/dev/null
ssh-add-defaults &>/dev/null

exit_session() {
    remove_old
    . "$ZDOTDIR/.zlogout"
}

trap exit_session SIGHUP

add-zsh-hook preexec save_cmd
add-zsh-hook precmd save_dir

export IGNORE_NEXT=false

remove_old() {
    sed -i "/$$/d" "$HOME/.cache/st-sessions"
}

save_cmd() {
    cwd="$(pwd)"
    cmd="$1"
    remove_old
    echo "cmd:$$|$cwd|$cmd" >> $HOME/.cache/st-sessions
}

save_dir() {
    cwd=$(pwd)
    remove_old
    echo "dir:$$|$cwd" >> $HOME/.cache/st-sessions
}

if ! [ -z $ST_PATH ]; then
    cd "$ST_PATH"
fi
