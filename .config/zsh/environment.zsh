# Vim aliases
alias vim="nvim -p"
alias nvim="nvim -p"
alias v="nvim"
alias vi="nvim"
alias sim="sudo vim"
# Vim envirnment
export JAR="/usr/share/java/jdtls/plugins/org.eclipse.equinox.launcher_*"
export GRADLE_HOME=$XDG_DATA_HOME/gradle
export JDTLS_CONFIG=/usr/share/java/jdtls/config_linux/
export WORKSPACE=$REPO_DIRECTORY

# Custom Commands
alias pulseaudio-start="pulseaudio --exit-idle-time=-1 --daemonize -vv"
alias node80="sudo node app.js"
alias update="yay -Syu --noconfirm"
alias Make='make -C $(git root)'

# Synonyms
alias quit="exit"
alias background="wallpaper"

# Permission aliases - don't @ me
alias shutdown="sudo shutdown -h now"
alias reboot="sudo reboot"
alias sudo='sudo '
#alias sudo="sudo -E"

# Shorter aliases
alias c="clear"
alias cn="clear && neofetch"
alias ct="cn"
alias pdf="zathura"

# Git aliases
alias g="git"
alias gc="git commit"
alias gs="git status"
alias gl="git log --oneline --decorate --all --graph"
alias ga="git add"
alias gr="git rm"
alias gp="git push"
alias gi="git ignore"

# Dot aliases
alias dots="git --git-dir=$HOME/.dots --work-tree=$HOME"
alias ds="dots status"
alias dl="dots log --oneline --decorate --all --graph"
alias dc="dots commit"
alias da="dots add"
alias dr="dots rm"
alias dp="dots push"
alias di="dots ignore --dots"

# Colors
alias ls="ls -ovH --color=auto --group-directories-first"
alias grep="grep --color=auto"
alias diff="diff --color=auto"

# Always Options
alias l="ls -A"
alias la="ls -a"
alias mkdir="mkdir -p"
alias mv="mv -v"
alias cp="cp -v"

# Define home
export HOME="/home/$USER"
export SHOME="$HOME"

# Exports
export PATH=$HOME/.local/bin:$HOME/.local/bin/xroot-panels:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/lib/jvm/default/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl

# XDG
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share

# Locale
export LANG="en_NZ.UTF-8"

# Default apps
export TERMINAL="st"
export BROWSER="google-chrome-stable"
export PDF_READER="zathura"
export EDITOR="nvim"
export VISUAL='st nvim'

# Runtimes
export JAVA_HOME="/usr/lib/jvm/default"
alias python3="python"

# Config paths
export SCRIPT_DIR="$HOME/.local/bin"
export REPO_DIRECTORY="$HOME/repos"
export TODO_DIRECTORY="$REPO_DIRECTORY/todo"

# Moving dot dirs to .config
export VIMINIT="source $HOME/.config/vim/init.vim"
export VIMDOTDIR="source $HOME/.config/vim"
export VIMDIR="$HOME/.config/vim"
export GNUPGHOME="$HOME/.config/gnupg"
export __GL_SHADER_DISK_CACHE_PATH="$HOME/.config/nvidia"
#export XAUTHORITY="$HOME/.config/X11/Xauthority"
export CARGO_HOME="$HOME/.local/share/cargo"
export NVM_DIR="$HOME/.config/nvm"
export LEIN_HOME="$XDG_DATA_HOME"/lein
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export LESSHISTFILE="$XDG_CACHE_HOME/less/history"
export _JAVA_OPTIONS="-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java"
alias wget="wget --hsts-file $HOME/.config/wget/wget-hsts"

# SSH Environment
alias ssh="ssh -F $HOME/.config/ssh/config -o UserKnownHostsFile=$HOME/.config/ssh/known_hosts"
alias ssh-copy-id="ssh-copy-id -F $HOME/.config/ssh/config -o UserKnownHostsFile=$HOME/.config/ssh/known_hosts"

export _JAVA_AWT_WM_NONREPARENTING=1    # Fix for Java applications in dwm
