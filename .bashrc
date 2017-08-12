# Unified .bashrc for natto

# Pre-hook
[[ -e "$HOME/.bashrc_prelocal" ]] && source $HOME/.bashrc_prelocal

# Nothing interesting? Get the fuck out
if [[ $- != *i* ]] ; then
    return
fi

# Aliases
LS='ls -lhALHF --color=auto --group-directories-first'

case $OSTYPE in
    solaris2.10)  alias ls='g$LS' ;;
    linux-gnu)  alias ls='$LS' ;;
    *)  alias ls='$LS' ;;
esac

alias clears="clear; echo -ne '\e[3J'"
alias ltmux="(cd $HOME; if tmux has 2> /dev/null; then tmux -u attach -t 0; else tmux -u new; fi)"
alias sctl=systemctl
alias g=git

# Exports
export EDITOR=vim
# Stop adding .local/bin so much.
echo $PATH | grep $HOME/.local/bin > /dev/null
if [[ "$?" == "1" ]]; then
    export PATH=$HOME/.local/bin:$PATH
fi

# Don't export xterm if we already exported screen (probably remote ssh)
[[ "$TERM" != "screen-256color" ]] && export TERM='xterm-256color'

# Only export screen if we're in tmux.
[[ -n "$TMUX" ]] && export TERM=screen-256color

# Terminal configuration

# So much overhead! It hurts!
function parse_git_branch {
  [[ -e `which git` && $HOME != `git rev-parse --show-toplevel 2>/dev/null` ]] && git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) /'
}

# Begone, colors!
PS1='[\D{%m/%d %R:%S}] \u \[$(tput bold)\]\w $(parse_git_branch)$ \[$(tput sgr0)\]'

# Standard(tm) window titles
TILDE="~"
PROMPT_TITLE='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/${TILDE}}\007"'
PROMPT_COMMAND="history -a; $PROMPT_TITLE; $PROMPT_COMMAND"

if [[ -n "$TMUX" ]]; then
    PROMPT_COMMAND='eval "$(tmux showenv | grep ^SSH_AUTH_SOCK || echo \":\"); export SSH_AUTH_SOCK";'" $PROMPT_COMMAND"
fi

# Multi-terminal history
shopt -s histappend
shopt -s cmdhist
HISTTIMEFORMAT='%F %T '
HISTFILESIZE=1000000
HISTSIZE=1000000

# Disable flow control
stty ixany
stty ixoff -ixon

# Try to automatically update 10% of the time
if [[ "$NO_UPDATE" != "1" && $RANDOM -lt 3276 ]]; then
    git --git-dir $HOME/.git --work-tree $HOME pull
    git --git-dir $HOME/.git --work-tree $HOME submodule update --init --recursive
fi

# Source any local changes
[[ -e "$HOME/.bashrc_local" ]] && source $HOME/.bashrc_local
