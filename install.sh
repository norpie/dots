#!/usr/bin/env bash

# This script clones my dotfiles and installs them

REPO="https://github.com/norpie/dots"
HOME_DIR=$(eval echo ~${SUDO_USER})
HOMES_DIR=$(dirname $HOME_DIR)

cd $HOMES_DIR &&
sudo rm -rf $HOME_DIR &&
sudo git clone $REPO $HOME_DIR &&
sudo chown -R $USER $HOME_DIR &&
cd $HOME_DIR &&
mv .git .dots
