alias apt-dance='sudo apt update; sudo apt upgrade; sudo apt autoremove; sudo apt autoclean'

alias ls='ls -lhAL --color=auto'

if command -v colordiff >/dev/null; then
    alias diff=colordiff
fi
