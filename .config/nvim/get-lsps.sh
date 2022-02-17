#!/bin/sh

sudo npm i -g vscode-langservers-extracted &&
sudo npm i -g bash-language-server &&
sudo npm i -g vim-language-server &&

sudo pacman -S texlab --noconfirm &&
sudo pacman -S clang --noconfirm &&
sudo pacman -S lua-language-server --noconfirm &&

sudo pip install python-lsp-server &&

echo "Succesfully installed all language servers"
