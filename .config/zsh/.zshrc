# Std err/out is redirected to /dev/null to avoid cluttering the terminal
# eval $(ssh-agent) 2>&1 >/dev/null ||
#     echo "error in ssh-agent"
# ssh-add-defaults 2>&1 >/dev/null
source /home/norpie/.config/zsh/prompt.zsh || echo "error in prompt"
# Abstraction
source /home/norpie/.config/zsh/plugins.zsh || echo "error in plugins"
source /home/norpie/.config/zsh/environment.zsh || echo "error in environment"
source /home/norpie/.config/zsh/functions.zsh || echo "error in functions"
source /home/norpie/.config/zsh/settings.zsh || echo "error in settings"
