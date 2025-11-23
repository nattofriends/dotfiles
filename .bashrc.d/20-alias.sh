alias apt-dance='sudo apt update; sudo apt upgrade; sudo apt autoremove; sudo apt autoclean'

LS=ls
if command -v gls >/dev/null; then
    LS=gls
fi

alias ls="$LS --all --color=auto --dereference-command-line --human-readable --classify --group-directories-first -l -v"

unset LS

if command -v colordiff >/dev/null; then
    alias diff=colordiff
fi

alias g=git
