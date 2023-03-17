# Plugins
source /home/norpie/.config/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh &>/dev/null
source /home/norpie/.config/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh &>/dev/null
source /home/norpie/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /home/norpie/.config/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# Plugin settings
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
export ZSH_AUTOSUGGEST_COMPLETION_IGNORE="git *"

# fast-syntax-highlighting theme
fast-theme zdharma &>/dev/null
