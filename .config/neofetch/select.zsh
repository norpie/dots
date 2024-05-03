#!/bin/zsh

[[ $# != 1 ]] && echo "one argument required" && exit 1
[[ ! -f $1 ]] && echo "file must exist" && exit 1

rm -rf config.conf
ln -s $1 config.conf
