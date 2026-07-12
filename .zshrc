# autoload -U compinit promptinit
#
# promptinit
# compinit

ZSH_THEME=""

# enable starship
eval "$(starship init zsh)"

# enable zoxide
eval "$(zoxide init zsh)"

# enable fzf
# Set up fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"

# enable direnv
# eval "$(direnv hook zsh)"

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

# fortune-kind | tee ~/fortune.txt | cowsay -s -f bong | tee ~/cowsay.txt

# To remind myself what it's all about
# Snippet to use fd to find the file, in case I move the file
# fd --base-directory=Log4Stell 2026\ Resolutions

# sed '1 { /^---/ { :a N; /\n---/! ba; d} }' ~/Log4Stell/02-Permanent/2026-01-02T0118\ 2026\ Resolutions.md | bat -l=md -p
