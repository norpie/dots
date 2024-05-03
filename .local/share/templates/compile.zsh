#!/bin/zsh
#
[[ $# -ne 1 ]] && echo "provide 1 argument" && exit 1

[[ ! -f $1 ]] && rm *.pdf && echo "$1 doesnt exist" && exit 1

file=${1:r}
mkdir -p .cache &&
    pdflatex -jobname=$file -halt-on-error -output-directory=.cache $file.tex &&
    mv .cache/$file.pdf . &&
    rm .cache -rf
