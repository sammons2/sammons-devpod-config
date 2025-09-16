# ~/.zshrc: Zsh configuration

# History configuration
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Set up completion system
autoload -U compinit
compinit

# Enable colors
autoload -U colors
colors

# Add mise to PATH and configure auto-trust
export PATH="$HOME/.local/share/mise/shims:$PATH"

# Auto-trust mise configuration files
if [ -f ~/.local/bin/mise ]; then
    export MISE_TRUSTED_CONFIG_PATHS="$HOME"
fi

# Activate mise for tool management
eval "$(~/.local/bin/mise activate zsh)"

# Enable color support of ls and add aliases
if [[ "$OSTYPE" == "linux-gnu"* ]] && [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
elif [[ "$OSTYPE" == "darwin"* ]]; then
    alias ls='ls -G'
fi

# Common aliases
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Simple prompt
PS1='%F{green}%n@%m%f:%F{blue}%~%f$ '