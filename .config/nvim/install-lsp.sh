#!/bin/sh

sudo npm i -g vscode-langservers-extracted &&
sudo npm i -g bash-language-server &&
sudo npm i -g vim-language-server &&

pip install python-lsp-server &&

sudo pacman -S texlab &&
sudo pacman -S clangd &&

echo "Succesfully installed all language servers"
