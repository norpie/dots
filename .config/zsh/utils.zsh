eval `ssh-agent`
ssh-add-defaults

exit_session() {
    . "$ZDOTDIR/.zlogout"
}

trap exit_session SIGHUP
