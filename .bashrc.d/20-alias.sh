alias ltmux="(cd $HOME; if tmux has 2> /dev/null; then exec tmux -u attach -t 0; else exec tmux -u new; fi)"
alias apt-dance='sudo apt update; sudo apt upgrade; sudo apt autoremove; sudo apt autoclean'

LS='ls -lhALHF --color=auto --group-directories-first'

case $OSTYPE in
    darwin*)  alias ls='g$LS' ;;
    linux-gnu)  alias ls='$LS' ;;
    *)  alias ls='$LS' ;;
esac
