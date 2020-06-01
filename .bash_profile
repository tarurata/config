
# PATH Settings
export PATH="/usr/local/bin:$PATH"
## Setting PATH for Python 3.5 and 3.6. Wrote by python installer?
## The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.5/bin:${PATH}"
PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"
## Setting PATH for rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
## Setting PATH for mysql
export PATH=$PATH:/usr/local/mysql/bin
export PATH="/usr/local/opt/php@7.2/bin:$PATH"
export PATH="/usr/local/opt/php@7.2/sbin:$PATH"

# added by Anaconda3 4.2.0 installer
#export PATH="/Users/muratawataru/anaconda3/bin:$PATH"
#source /usr/local/bin/virtualenvwrapper.sh
#export WORKON_HOME=~/.virtualenvs

if [ -f ~/.bashrc ] ; then
. ~/.bashrc
fi

if [ -f $(brew --prefix)/etc/bash_completion  ]; then
    . $(brew --prefix)/etc/bash_completion
fi

screen
