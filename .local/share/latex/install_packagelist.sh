#!/bin/zsh

while read line; do
    echo -ne "\n" | tllocalmgr install $line
done < packagelist.txt

sudo texhash
