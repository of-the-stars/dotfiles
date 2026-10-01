# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias c="clear"
alias eza='eza --icons auto --color auto --git'
alias icat="kitten icat"
alias l="eza -a --sort=type --group-directories-first"
alias la='eza -A'
alias ll='eza -alF'
alias v="nvim"
