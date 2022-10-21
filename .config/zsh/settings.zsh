# History file
export HISTFILE=$HOME/.cache/zsh/histfile
export HISTSIZE=1000000
export SAVEHIST=1000000
export HISTCONTROL=ignoreboth:erasedumps

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# Auto-complete
autoload -U compinit
setopt prompt_subst
setopt PROMPT_SUBST
setopt histignoredups
setopt inc_append_history share_history
compinit
_comp_options+=(globdots)
fast-theme clean &>/dev/null
