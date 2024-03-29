# Vim aliases
alias vi="vim"
alias v="vim"
alias sim="sudo vim"

function nvim() {
    if [[ $# == 0 ]]; then
        /usr/bin/nvim .
    else
        /usr/bin/nvim -p "$@"
    fi
}

which nvim &>/dev/null
if [[ $? == 0 ]]; then
    alias vim="nvim"
fi

which neovide &>/dev/null
if [[ $? == 0 && -v DISPLAY ]]; then
    #alias nvim="neovide"
fi

alias neovide="neovide --nofork"

# JAVA environment
# export JAR="/usr/share/java/jdtls/plugins/org.eclipse.equinox.launcher_*"
# export GRADLE_HOME=$XDG_DATA_HOME/gradle
# export JDTLS_CONFIG=/usr/share/java/jdtls/config_linux/
export WORKSPACE=$REPO_DIR/fantasy/mc/workspace
export STUDY=/home/norpie/hs

# Alternatives
which rsync &>/dev/null
if [[ $? == 0 ]]; then
    alias cp="rsync -avz --progress"
fi

which duf &>/dev/null
if [[ $? == 0 ]]; then
    function df() {
        if [[ $@ == "" ]]; then
            duf -only local,fuse
        else
            duf $@
        fi
    }
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

alias exit="remove_old && exit"

# Synonyms
alias quit="exit"
alias background="wallpaper"
alias doc2pdf="unoconv -f pdf"

# filetype association
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
alias docker="sudo docker"
alias docker-compose="sudo docker-compose"
alias sudo='sudo '

# Shorter aliases
alias c="clear"
alias b="back"
alias e="exit"
alias q="quit"

# Git aliases
alias g="git"
alias gc="git commit"
alias gb="git branch"
alias gs="git status"
alias gf="git fetch"
alias gl="git log --oneline --decorate --all --graph"
alias ga="git add"
alias gr="git rm"
alias gp="git push"
alias gpl="git pull"
alias gi="git ignore"
alias gpr="git pull-request"
alias gch="git checkout"
alias gcb="git checkout -b"

# Dot aliases
alias ds="dots status"
alias dl="dots log --oneline --decorate --all --graph"
alias dc="dots commit"
alias da="dots add"
alias dr="dots rm"
alias dp="dots push --recurse-submodules=on-demand"
alias dpl="dots pull && dots submodule update --init --recursive"
alias dlg="lazygit -g ~/.dots"
alias di="dots ignore --dots"

# Monero
alias monerod="monerod --data-dir $XDG_DATA_HOME/bitmonero"
alias monero-wallet-gui="monero-wallet-gui --log-file=/dev/null"
alias monero-wallet-cli="monero-wallet-cli --log-file=/dev/null --shared-ringdb-dir=$XDG_DATA_HOME/shared-ringdb"

# Colors
export LS_COLORS="tw=00;33:ow=01;33:"
alias ls="ls -ovHh --color=auto --group-directories-first"
alias grep="grep --color=auto"
alias diff="diff --color=auto"

# Always Options
alias l="ls -hA"
alias la="ls -ha"
alias mkdir="mkdir -p"
alias mv="mv -v"

alias monitor-brightness="xrandr -q | grep \" connected\" | awk '{print \$1}' | xargs -I {} xrandr --output {} --brightness"

# Compiler flags
alias g++="g++ -Wall -pedantic-errors -std=c++11"

# Define home
export HOME="/home/$USER"

# XDG
export XDG_CONFIG_HOME=/home/norpie/.config
export XDG_CACHE_HOME=/home/norpie/.cache
export XDG_DATA_HOME=/home/norpie/.local/share
export XDG_STATE_HOME=/home/norpie/.local/state
export XDG_LOCAL_BIN=/home/norpie/.local/bin
export XDG_DATA_GAMES=/home/norpie/.local/share/games
export XDG_DOWNLOADS_HOME=/home/norpie/Downloads

# Locale
export LANG="en_NZ.UTF-8"

# Default apps
export TERMINAL="st"
export BROWSER="chrome"
export PDF_READER="zathura"
export EDITOR="nvim"
export VISUAL="st -e nvim"

# Case insensitivty for defaul apps
export browser="$BROWSER"

alias google-chrome="chrome"
# alias google-chrome-stable="chrome" dangerous

# Runtimes
export JAVA_HOME="/usr/lib/jvm/default"
alias python3="python"
alias pypy="pypy3"
alias activate="source .venv/bin/activate"
alias dotenv='source .env'

# Config paths
export SCRIPT_DIR="/home/norpie/.local/bin"
export REPO_DIR="/home/norpie/repos"
export TODO_DIR="$XDG_DATA_HOME/todo"
export KERNELS_DIR="$REPO_DIR/kernels/linux-lts-arch"

# Moving dot dirs to .config
export GOPATH="$XDG_DATA_HOME"/go
export GOBIN="$XDG_DATA_HOME"/go/bin
export GOMODCACHE="$XDG_CACHE_HOME"/go/mod
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
export VIMINIT="source $XDG_CONFIG_HOME/nvim/init.lua"
export VIMDOTDIR="source $XDG_CONFIG_HOME/nvim"
export VIMDIR="$XDG_CONFIG_HOME/nvim"
export TEXMFVAR="$XDG_CACHE_HOME"/texlive/texmf-var
export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export __GL_SHADER_DISK_CACHE_PATH="$XDG_CONFIG_HOME/nvidia"
#export XAUTHORITY="$XDG_CONFIG_HOME/X11/Xauthority"
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc
export NVM_DIR="$XDG_CONFIG_HOME/nvm"
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
export SCREENRC="$XDG_CONFIG_HOME/screen/screenrc"
export LEIN_HOME="$XDG_DATA_HOME"/lein
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export LESSHISTFILE="$XDG_CACHE_HOME/less/history"
export _JAVA_OPTIONS="-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java"
export TEXMFHOME=$XDG_DATA_HOME/texmf
export TEXMFVAR=$XDG_CACHE_HOME/texlive/texmf-var
export TEXMFCONFIG=$XDG_CONFIG_HOME/texlive/texmf-config
alias wget="wget --hsts-file $XDG_CONFIG_HOME/wget/wget-hsts"
alias mvn="mvn -gs $XDG_CONFIG_HOME/maven/settings.xml"
alias yarn='yarn --use-yarnrc "$XDG_CONFIG_HOME/yarn/config"'

# Hardware acceleration
# export LIBVA_DRIVER_NAME=nvidia
if [[ $HOST == "desktop" ]]; then
    export LIBVA_DRIVER_NAME=nvidia
    export VDPAU_DRIVER=nvidia
elif [[ $HOST == "laptop" ]]; then
    export LIBVA_DRIVER_NAME=radeonsi
    # export VDPAU_DRIVER=radeonsi
fi

# Rust
export CARGO_HOME="/home/norpie/.local/share/cargo"
#export RUSTC_WRAPPER="/home/norpie/.local/share/cargo/bin/sccache"

# QT
export QT_QPA_PLATFORMTHEME="gtk2"

# Tor
## Use system daemon socks port
export TOR_SOCKS_PORT=9050
# Use system daemon control port
export TOR_CONTROL_PORT=9051
# Don't launch a second tor instance, and don't take ownership of it.
export TOR_SKIP_LAUNCH=1
# Tell it where to find the control auth cookie
export TOR_CONTROL_COOKIE_AUTH_FILE=/var/run/tor/control.authcookie

# Dev Env
export POSTGRES_URL="postgres://user:postgres@localhost:5432/harmonize"

# SSH Environment
alias ssh="ssh -F $XDG_CONFIG_HOME/ssh/config -o UserKnownHostsFile=/home/norpie/.config/ssh/known_hosts"
alias sshfs="sshfs -F /home/norpie/.config/ssh/config -o UserKnownHostsFile=/home/norpie/.config/ssh/known_hosts"
alias ssh-copy-id="ssh-copy-id -F $XDG_CONFIG_HOME/ssh/config -o UserKnownHostsFile=/home/norpie/.config/ssh/known_hosts"

export _JAVA_AWT_WM_NONREPARENTING=1    # Fix for Java applications in dwm

# Exports
export PATH="\
/home/norpie/.local/share/spicetify\
:$STUDY/.bin\
:/home/norpie/.local/bin\
:/home/norpie/.local/share/cargo/bin\
:/home/norpie/.local/bin/xroot-panels\
:/usr/lib/jvm/default/bin\
:$XDG_DATA_HOME/go/bin\
:$PATH\
"
