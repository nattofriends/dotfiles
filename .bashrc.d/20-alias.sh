alias apt-dance='sudo apt update; sudo apt upgrade; sudo apt autoremove; sudo apt autoclean'

alias ls='ls --almost-all --color=auto --dereference-command-line --dereference --human-readable --classify --group-directories-first -l -v'

if command -v colordiff >/dev/null; then
    alias diff=colordiff
fi
