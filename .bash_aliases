# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=high -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# internet_wizard's custom aliases
# alias cat='bat'
alias icat="kitten icat"
alias cd="z"
alias c="clear"
alias ls="eza"

# internet_wizard's custom functions
lg() {
    # ls -a | rg alias
    ls | rg $1
}

# yazi alias
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# panasonic camcorder helper functions

panasonic-grab() {
    # pulls video and splits recordings into .avi files from my Panasonic camcorder
    dvgrab -V -input $1 --timestamp --size 0 --showstatus --autosplit --format dv2 dv-
    panasonic-rename
}

panasonic-rename() {
    # renames the videos grabbed by the panasonic-grab() function into ISO compliant filenames with the date and time
    rename -v 's/dv-19([0-9]{2}).([0-9]{2}).([0-9]{2})_([0-9]{2})-([0-9]{2})-([0-9]{2})/20$1$2$3T$4$5$6/' *
}

# unzip-all

unzip-all() {
    for a in *.zip; do unzip "$a" -d "${a%.zip}"; done
}
