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
#alias findn='find ./ -name'

# Functions
function grepr(){ command grep -r ${1} ./; }

# Find files from the current directory (and subdirectories) and open with vim
function fvim(){
    findResutl=$(find . -name ${1} | cut -c 3- )
    echo "$findResutl" | nl
    read -p "Which file?(Enter the number): " input
    echo "$findResutl" | awk -v rownum=$input 'NR==rownum'| xargs -o vim
}

# Change Color for ls -G -> dir color blue to cyan
export LSCOLORS=gxfxcxdxbxegedabagacad
