# Use lynx as default browser.
export BROWSER=lynx

# For bash history settings
export HISTTIMEFORMAT="%h %d %H:%M:%S "
export HISTSIZE=10000
export HISTFILESIZE=10000

# To append commands to the history file, rather than overwrite it.
shopt -s histappend

# Do not save ls, ps and history commands.
export HISTIGNORE="ls:ps:history"

# Show only current directory on bash prompt.
export PS1="\[\e[33m\]\W\[\e[m\]\[\e[33m\]\\$\[\e[m\] "

# Aliases
#alias l="~/login.exp"
alias ls='ls -FG'
