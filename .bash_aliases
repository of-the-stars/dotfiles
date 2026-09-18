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
alias icat="kitten icat"
alias ls="eza";
alias l="ls -a --sort=type --group-directories-first"
alias la='ls -A'
alias ll='ls -alF'
alias v="nvim"
