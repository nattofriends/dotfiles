export EDITOR=vim

# Multi-terminal history
shopt -s cmdhist histappend histreedit histverify
HISTCONTROL=ignoreboth
HISTFILESIZE=1000000
HISTIGNORE='ls:bg:fg:history'
HISTSIZE=10000
HISTTIMEFORMAT='%F %T '

# Disable flow control
stty ixany ixoff -ixon

# Enable readline and history for Python interactive
export PYTHONSTARTUP=~/.pythonrc.py

# Begone, colors!
PS1='[\D{%m/%d %R:%S}] \u \[$(tput bold)\]\w $(git_branch)$ \[$(tput sgr0)\]'

# Standard(tm) window titles
TILDE="~"
PROMPT_TITLE='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/${TILDE}}\007"'
PROMPT_COMMAND="history -a; $PROMPT_TITLE"

pathadd $HOME/.metapath
