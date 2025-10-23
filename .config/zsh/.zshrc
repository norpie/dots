# Use cached SSH agent from Hyprland init if available
if [[ -f ~/.cache/ssh_auth_sock && -f ~/.cache/ssh_agent_pid ]]; then
    export SSH_AUTH_SOCK=$(cat ~/.cache/ssh_auth_sock)
    export SSH_AGENT_PID=$(cat ~/.cache/ssh_agent_pid)
    
    # Verify the agent is still running
    if ! kill -0 $SSH_AGENT_PID 2>/dev/null; then
        echo "Cached SSH agent is dead, starting new one"
        eval $(ssh-agent -s)
        ssh-add-defaults
    fi
elif [[ ! -v SSH_AGENT_PID ]]; then
    echo "No cached SSH agent, starting new one"
    eval $(ssh-agent -s)
    ssh-add-defaults
fi

# Auto-start tmux only in WSL
if [[ -f /proc/version ]] && grep -qi microsoft /proc/version; then
  if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
    export TERM=xterm-256color
    exec tmux new-session -A -s default
  fi
fi

source /home/norpie/.config/zsh/prompt.zsh || echo "error in prompt"
source /home/norpie/.config/zsh/plugins.zsh || echo "error in plugins"
source /home/norpie/.config/zsh/environment.zsh || echo "error in environment"
source /home/norpie/.config/zsh/functions.zsh || echo "error in functions"
source /home/norpie/.config/zsh/settings.zsh || echo "error in settings"
