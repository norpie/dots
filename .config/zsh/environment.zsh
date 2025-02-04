# Usage: if_exists_alias <alias_name> <command>
# E.g.: if_exists_alias vim nvim
# E.g.: if_exists_alias cat bat
function if_exists_alias() {
    which $2 &>/dev/null
    if [[ $? == 0 ]]; then
        alias $1=$2
        return 0
    fi
    return 1
}

if_exists_alias top htop
if_exists_alias top btop
if_exists_alias top btm
if_exists_alias fetch neofetch
if_exists_alias fetch pfetch
if_exists_alias fetch fastfetch
if_exists_alias cat bat
if_exists_alias df duf
if_exists_alias cp rsync

if_exists_alias ls eza # exa is unmaintained and eza is a fork of it
eza_exists=$?
if [[ $eza_exists == 0 ]]; then
    alias eza="eza --color=always --icons=automatic --git --group-directories-first"
    alias la="eza -l"
    alias l="la -a"
fi
[[ $eza_exists == 1 ]] &&
    alias ls="ls -ovHh --color=auto --group-directories-first" &&
    alias l="ls -ovHhA --color=auto --group-directories-first" &&
    alias la="ls -ovHha --color=auto --group-directories-first"

if_exists_alias vim nvim
[[ $? == 0 ]] && export VIMINIT="source $XDG_CONFIG_HOME/nvim/init.lua"

function nvim() {
    if [[ $# == 0 ]]; then
        command nvim
    else
        command nvim -p "$@"
    fi
}

function duf() {
    if [[ $@ == "" ]]; then
        command duf -only local,fuse
    else
        command duf $@
    fi
}

# Vim aliases
alias vi="vim"
alias v="vim"
alias sim="sudo vim"

# Custom Commands
alias Make='make -C $(git root)'
alias chmox="chmod +x"
alias monitor-brightness="xrandr -q | grep \" connected\" | awk '{print \$1}' | xargs -I {} xrandr --output {} --brightness"
alias doc2pdf="unoconv -f pdf"

# Systemd
alias sys="sudo systemctl"
alias usys="systemctl --user"

# Synonyms
alias quit="exit"
alias background="wallpaper"

# Permission aliases - don't @ me
alias shutdown="xorg-state-save && sudo shutdown -h now"
alias reboot="xorg-state-save && sudo reboot"
alias sudo='sudo '

# Shorter aliases
alias c="clear"
alias b="back"
alias e="exit"
alias q="quit"

# Git aliases
alias g="git"
alias gc="git commit"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gb="git branch"
alias gd="git diff"
alias gds="git diff --staged"
alias gs="git status -s"
alias gf="git fetch"
alias gl="git log --oneline --decorate --all --graph"
alias ga="git add"
alias gr="git rm"
alias gp="git push"
alias gpl="git pull --rebase"
alias gi="git ignore"
alias gpr="git pull-request"
alias lg="lazygit"

# Dot aliases
alias ds="dots status"
alias dl="dots log --oneline --decorate --all --graph"
alias dc="dots commit"
alias da="dots add"
alias dr="dots rm"
alias dp="dots push --recurse-submodules=on-demand"
alias dpl="dots pull && dots submodule update --init --recursive"
alias dlg="cd && lazygit -g $HOME/.dots && back"
alias di="dots ignore --dots"

# Always options
alias grep="grep --color=auto"
alias diff="diff --color=auto"
alias rsync="rsync -avz --progress"
alias mkdir="mkdir -p"
alias mv="mv -v"
alias nix-shell="HISTFILE=/dev/null nix-shell"

# Define home
export HOME="/home/$USER"

# XDG
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_DATA_DIRS=$HOME/.local/share:/usr/local/share:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share
export XDG_STATE_HOME=$HOME/.local/state
export XDG_LOCAL_BIN=$HOME/.local/bin
export XDG_DATA_GAMES=$HOME/.local/share/games
export XDG_DOWNLOADS_HOME=$HOME/Downloads

# Locale
export LANG="en_US.UTF-8"

# Application settings
# export LS_COLORS="tw=00;33:ow=01;33:"
alias bat="bat --theme=Catppuccin\ Mocha"
export EZA_COLORS="\
uu=36:\
gu=37:\
sn=32:\
sb=32:\
da=34:\
ur=34:\
uw=35:\
ux=36:\
ue=36:\
gr=34:\
gw=35:\
gx=36:\
tr=34:\
tw=35:\
tx=36:"
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

# Default apps
export TERMINAL="st"
export EDITOR="nvim"
export VISUAL="st -e nvim"
export BROWSER="firefox"
export PDF_READER="zathura"
export VIDEO_PLAYER="mpv"
export IMAGE_VIEWER="sxiv"

# filetype association
alias pdf="$PDF_READER"
alias url="$BROWSER"
alias txt="$EDITOR"
alias img="$IMAGE_VIEWER"
alias vid="$VIDEO_PLAYER"

# Runtimes
export JAVA_HOME="/usr/lib/jvm/default"
alias activate="source .venv/bin/activate"
alias dotenv='source .env'

# Config paths
export SCRIPT_DIR="$HOME/.local/bin"
export STUDY=$HOME/hs
export REPO_DIR="$HOME/repos"
export FLAKE="$HOME/repos/nix"

# Moving dot dirs to .config
export WAKATIME_HOME="$XDG_CONFIG_HOME/wakatime"
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
export STEAM_HOME="$HOME/.local/data/steam" # together with .local/bin/steam script
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
export XCOMPOSEFILE="$XDG_CONFIG_HOME"/X11/xcompose
export XCOMPOSECACHE="$XDG_CACHE_HOME"/X11/xcompose
export USERXSESSION="$XDG_CACHE_HOME/X11/xsession"
export USERXSESSIONRC="$XDG_CACHE_HOME/X11/xsessionrc"
export ALTUSERXSESSION="$XDG_CACHE_HOME/X11/Xsession"
export ERRFILE="$XDG_CACHE_HOME/X11/xsession-errors"
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
if [[ $HOST == "desktop" ]]; then
    export LIBVA_DRIVER_NAME=radeonsi
    export VDPAU_DRIVER=radeonsi
fi

# Instead of exit on tmux:
#   * If there are panes, close the current pane
#   * If there is only one pane, close the window
#   * If there is only one window, close the session
function tmux_exit() {
    if [[ $(tmux list-panes | wc -l) -gt 1 ]]; then
        tmux kill-pane
    elif [[ $(tmux list-windows | wc -l) -gt 1 ]]; then
        tmux kill-window
    else
        tmux kill-session
    fi
}

if [[ ! $TMUX == "" && ! $SSH_CONNECTION == "" ]]; then
    alias exit="tmux_exit"
fi

# Rust
export CARGO_HOME="$HOME/.local/share/cargo"

# QT
export QT_QPA_PLATFORMTHEME="gtk2"

# SSH Environment
alias ssh="ssh -F $XDG_CONFIG_HOME/ssh/config -o UserKnownHostsFile=$HOME/.config/ssh/known_hosts"
alias sshfs="sshfs -F $HOME/.config/ssh/config -o UserKnownHostsFile=$HOME/.config/ssh/known_hosts"
alias ssh-copy-id="ssh-copy-id -F $XDG_CONFIG_HOME/ssh/config -o UserKnownHostsFile=$HOME/.config/ssh/known_hosts"

export _JAVA_AWT_WM_NONREPARENTING=1    # Fix for Java applications in dwm
export WEBKIT_DISABLE_DMABUF_RENDERER=1 # Fix for webkitgtk in dwm

# Rust toolchain bins
# e.g. $RUSTUP_HOME/toolchains/stable-x86_64-unknown-linux-gnu/bin/cargo
# Put every $RUSTUP_HOME/toolchain/**/bin in $PATH
# RUST_PATHS=$(find $RUSTUP_HOME/toolchains -maxdepth 2 -type d -name "bin" | tr '\n' ':' | sed 's/.$//')
# RUST_DEFAULT_TOOLCHAIN=$(cat $HOME/.local/share/rustup/settings.toml | grep default_toolchain | awk '{print $3}' | sed s/\"//g)
# RUSTUP_TOOLCHAIN_PATH=$HOME/.local/share/rustup/toolchains/$RUST_DEFAULT_TOOLCHAIN/bin

# Exports
export PATH="\
$HOME/.local/share/spicetify\
:$STUDY/.bin\
:$HOME/.local/bin\
:$HOME/.local/share/cargo/bin\
:$HOME/.local/bin/xroot-panels\
:/usr/lib/jvm/default/bin\
:/var/lib/flatpak/exports/bin\
:$XDG_DATA_HOME/go/bin\
# :$RUSTUP_TOOLCHAIN_PATH\
:$PATH"
