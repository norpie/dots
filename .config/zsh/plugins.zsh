# Plugins
source /home/norpie/.config/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh &>/dev/null
source /home/norpie/.config/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh &>/dev/null
source /home/norpie/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Plugin settings
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
export ZSH_AUTOSUGGEST_COMPLETION_IGNORE="git *"

# fast-syntax-highlighting theme
# fast-theme zdharma &>/dev/null

() {
   local -a prefix=( '\e'{\[,O} )
   local -a up=( ${^prefix}A ) down=( ${^prefix}B )
   local key=
   for key in $up[@]; do
      bindkey "$key" history-substring-search-up
   done
   for key in $down[@]; do
      bindkey "$key" history-substring-search-down
   done
}

zstyle ':autocomplete:*' widget-style menu-complete
# complete-word: (Shift-)Tab inserts the top (bottom) completion.
# menu-complete: Press again to cycle to next (previous) completion.
# menu-select:   Same as `menu-complete`, but updates selection in menu.
# ⚠️  NOTE: This setting can NOT be changed at runtime.

# Insert substring before
# zstyle ':autocomplete:*' insert-unambiguous yes
# zstyle ':autocomplete:*complete*:*' insert-unambiguous yes
# zstyle ':autocomplete:menu-search:*' insert-unambiguous yes
# zstyle ':autocomplete:*history*:*' insert-unambiguous no

source /home/norpie/.config/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh

bindkey '^I' up-line-or-search
bindkey '^[[Z' down-line-or-search
