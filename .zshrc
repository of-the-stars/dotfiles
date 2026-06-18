# autoload -U compinit promptinit
#
# promptinit
# compinit

# enable starship
eval "$(starship init zsh)"

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

bindkey -v
bindkey '^E' autosuggest-accept
bindkey -M vicmd ' ' edit-command-line

export MANPAGER="nvim +Man!"

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	command rm -f -- "$tmp"
}

alias l="eza -a --sort=type --group-directories-first"
