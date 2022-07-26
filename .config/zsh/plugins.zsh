# Plugins
source ~/.config/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh &>/dev/null
source ~/.config/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh &>/dev/null

# Plugin settings
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# fast-syntax-highlighting theme
fast-theme zdharma &>/dev/null
