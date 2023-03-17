# History file
export HISTFILE=/home/norpie/.cache/zsh/histfile
export HISTSIZE=1000000
export SAVEHIST=1000000
export HISTCONTROL=ignoreboth:erasedumps

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# Auto-complete
skip_global_compinit=1
#autoload -U compinit -C
setopt prompt_subst
setopt PROMPT_SUBST
setopt inc_append_history share_history
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
#compinit -C
#_comp_options+=(globdots)
fast-theme clean &>/dev/null
