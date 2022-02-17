function ctrl-p() {
    file=$(find | fzf --preview 'pygmentize {}')
    [[ -d $file ]] && cd $file
    [[ -f $file ]] && $EDITOR $file
}
