eval `ssh-agent` &>/dev/null
ssh-add-defaults &>/dev/null

exit_session() {
    . "$ZDOTDIR/.zlogout"
}

trap exit_session SIGHUP
