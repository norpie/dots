function template() {
    file=$(find $XDG_DATA_HOME/templates -maxdepth 1 | fzf --preview 'pygmentize {}')
    [[ -d $file ]] && cd $file
    [[ -f $file ]] && clear && echo "Enter a filename: " && read filename && cp $file $filename
}
