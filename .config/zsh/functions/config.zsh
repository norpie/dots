function config() {
    file=$(find $XDG_CONFIG_HOME -maxdepth 3 | fzf --preview 'pygmentize {}')
    [[ -d $file ]] && cd $file
    [[ -f $file ]] && $EDITOR $file
}
