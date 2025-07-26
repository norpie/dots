if [[ ! -v SSH_AGENT_PID ]]; then
    echo "Missing SSH agent"
    eval $(ssh-agent -s)
    ssh-add-defaults
fi

if [[ ! -v TMUX && -o interactive ]]; then
    echo "Starting tmux"
    tmux
fi

source /home/norpie/.config/zsh/prompt.zsh || echo "error in prompt"
source /home/norpie/.config/zsh/plugins.zsh || echo "error in plugins"
source /home/norpie/.config/zsh/environment.zsh || echo "error in environment"
source /home/norpie/.config/zsh/functions.zsh || echo "error in functions"
source /home/norpie/.config/zsh/settings.zsh || echo "error in settings"
