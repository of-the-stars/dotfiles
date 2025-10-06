
# Home Manager
source "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh"

# enable starship
# eval "$(starship init zsh)"

# enable zoxide
eval "$(zoxide init zsh)"

# enable fzf
# Set up fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"

# enable direnv
eval "$(direnv hook zsh)"

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
