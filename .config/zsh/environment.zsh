# Vim aliases
alias vim="vim -p"
alias vi="vim"
alias v="vim"
alias sim="sudo vim"
which nvim &>/dev/null
if [[ $? == 0 ]]; then
    alias vim="nvim"
fi

# JAVA environment
# export JAR="/usr/share/java/jdtls/plugins/org.eclipse.equinox.launcher_*"
# export GRADLE_HOME=$XDG_DATA_HOME/gradle
# export JDTLS_CONFIG=/usr/share/java/jdtls/config_linux/
export WORKSPACE=$REPO_DIRECTORY/fantasy/mc/workspace
export UNIVERSITY=$HOME/uni

# Alternatives
which duf &>/dev/null
if [[ $? == 0 ]]; then
    alias df=duf
fi

which htop &>/dev/null
if [[ $? == 0 ]]; then
    alias top=htop
fi

which btop &>/dev/null
if [[ $? == 0 ]]; then
    alias top=btop
fi

which neofetch &>/dev/null
if [[ $? == 0 ]]; then
    alias fetch=neofetch
fi

which pfetch &>/dev/null
if [[ $? == 0 ]]; then
    alias fetch=pfetch
fi

# Custom Commands
alias pulseaudio-start="pulseaudio --exit-idle-time=-1 --daemonize -vv"
alias node80="sudo node app.js"
alias Make='make -C $(git root)'
alias chmox="chmod +x"

# Systemd
alias sys="sudo systemctl"
alias usys="systemctl --user"

# Pacman/Yay commands
alias update="yay -Syu --noconfirm"
alias u="update"
alias p="sudo pacman"
alias y="yay"

# Synonyms
alias quit="exit"
alias background="wallpaper"

# Standard programs
alias pdf="zathura"
alias url="$BROWSER"
alias txt="vim"
alias img="sxiv"
alias vid="mpv"

# Capitalisation
alias readme="README"

# Permission aliases - don't @ me
alias shutdown="xorg-state-save && sudo shutdown -h now"
alias reboot="xorg-state-save && sudo reboot"
alias sudo='sudo '
#alias sudo="sudo -E"

# Shorter aliases
alias c="clear"
alias cn="clear && neofetch"
alias cf="clear && neofetch"
alias nf="neofetch"
alias e="exit"
alias q="quit"

# Git aliases
alias g="git"
alias gc="git commit"
alias gb="git branch"
alias gs="git status"
alias gl="git log --oneline --decorate --all --graph"
alias ga="git add"
alias gr="git rm"
alias gp="git push"
alias gpl="git pull"
alias gi="git ignore"

# Dot aliases
alias ds="dots status"
alias dl="dots log --oneline --decorate --all --graph"
alias dc="dots commit"
alias da="dots add"
alias dr="dots rm"
alias dp="dots push"
alias dpl="dots pull"
alias di="dots ignore --dots"

# Monero
alias monerod="monerod --data-dir $XDG_DATA_HOME/bitmonero"
alias monero-wallet-gui="monero-wallet-gui --log-file=/dev/null"
alias monero-wallet-cli="monero-wallet-cli --log-file=/dev/null --shared-ringdb-dir=$XDG_DATA_HOME/shared-ringdb"

# Colors
export LS_COLORS="tw=00;33:ow=01;33:"
alias ls="ls -ovH --color=auto --group-directories-first"
alias grep="grep --color=auto"
alias diff="diff --color=auto"

# Always Options
alias l="ls -A"
alias la="ls -a"
alias mkdir="mkdir -p"
alias mv="mv -v"
alias cp="rsync -avz --progress"

# Define home
export HOME="/home/$USER"
export SHOME="$HOME"

# Exports
export PATH=$HOME/repos/dnm/.bin:$HOME/.local/share/monero/bin:$HOME/uni/.bin:$HOME/.local/bin:$HOME/.local/bin/xroot-panels:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/lib/jvm/default/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl

# XDG
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_LOCAL_BIN=$HOME/.local/bin
export XDG_DATA_GAMES=$HOME/.local/share/games

# Locale
export LANG="en_NZ.UTF-8"

# Default apps
export TERMINAL="st"
export BROWSER="chrome"
export PDF_READER="zathura"
export EDITOR="nvim"
export VISUAL='st nvim'

# Case insensitivty for defaul apps
export browser="$BROWSER"

alias google-chrome="chrome"
alias google-chrome-stable="chrome"

# Runtimes
export JAVA_HOME="/usr/lib/jvm/default"
alias python3="python"
alias activate="source .venv/bin/activate"

# Config paths
export SCRIPT_DIR="$HOME/.local/bin"
export REPO_DIRECTORY="$HOME/repos"
export TODO_DIRECTORY="$REPO_DIRECTORY/todo"

# Moving dot dirs to .config
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
export VIMINIT="source $XDG_CONFIG_HOME/nvim/init.lua"
export VIMDOTDIR="source $XDG_CONFIG_HOME/nvim"
export VIMDIR="$XDG_CONFIG_HOME/nvim"
export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"
export __GL_SHADER_DISK_CACHE_PATH="$XDG_CONFIG_HOME/nvidia"
#export XAUTHORITY="$XDG_CONFIG_HOME/X11/Xauthority"
export CARGO_HOME="$HOME/.local/share/cargo"
export NVM_DIR="$XDG_CONFIG_HOME/nvm"
export SCREENRC="$XDG_CONFIG_HOME/screen/screenrc"
export LEIN_HOME="$XDG_DATA_HOME"/lein
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export LESSHISTFILE="$XDG_CACHE_HOME/less/history"
export _JAVA_OPTIONS="-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java"
alias wget="wget --hsts-file $XDG_CONFIG_HOME/wget/wget-hsts"
alias mvn="mvn -gs $XDG_CONFIG_HOME/maven/settings.xml"
export TEXMFHOME=$XDG_DATA_HOME/texmf
export TEXMFVAR=$XDG_CACHE_HOME/texlive/texmf-var
export TEXMFCONFIG=$XDG_CONFIG_HOME/texlive/texmf-config

# SSH Environment
alias ssh="ssh -F $XDG_CONFIG_HOME/ssh/config -o UserKnownHostsFile=$HOME/.config/ssh/known_hosts"
alias ssh-copy-id="ssh-copy-id -F $XDG_CONFIG_HOME/ssh/config -o UserKnownHostsFile=$HOME/.config/ssh/known_hosts"

export _JAVA_AWT_WM_NONREPARENTING=1    # Fix for Java applications in dwm
