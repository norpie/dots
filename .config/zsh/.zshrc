eval $(ssh-agent)
ssh-add-defaults
# Abstraction
source /home/norpie/.config/zsh/plugins.zsh || echo "error in plugins"
source /home/norpie/.config/zsh/environment.zsh || echo "error in environment"
source /home/norpie/.config/zsh/functions.zsh || echo "error in functions"
source /home/norpie/.config/zsh/prompt.zsh || echo "error in prompt"
source /home/norpie/.config/zsh/settings.zsh || echo "error in settings"
