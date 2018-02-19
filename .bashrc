# Unified .bashrc for natto

# Pre-hook
[[ -e "$HOME/.bashrc_prelocal" ]] && source $HOME/.bashrc_prelocal

# Not interactive? Get out early
if [[ $- != *i* ]] ; then
    return
fi

# Aliases
LS='ls -lhALHF --color=auto --group-directories-first'

case $OSTYPE in
    darwin*)  alias ls='g$LS' ;;
    linux-gnu)  alias ls='$LS' ;;
    *)  alias ls='$LS' ;;
esac

alias clears="clear; echo -ne '\e[3J'"
alias ltmux="(cd $HOME; if tmux has 2> /dev/null; then exec tmux -u attach -t 0; else exec tmux -u new; fi)"
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
PROMPT_COMMAND="history -a; $PROMPT_TITLE"

# Sockminder

# 1. Before every command, link .ssh/sock to the most recently active client.
function relink_sock {
    if [[ "$RELINK_DONE" == "1" ]]; then
        return
    fi

    # Link the sock to the most recent client
    # If the client didn't have a SSH_AUTH_SOCK, this will be just empty.
    ln -sf $(grep -aPo '(?<=SSH_AUTH_SOCK=)[^\0]+' /proc/$(tmux list-clients -F "#{client_activity} #{client_pid}" | sort -r | head -n 1 | cut -d ' ' -f 2)/environ) ~/.ssh/sock

    RELINK_DONE=1
}

# 2. Clear the early return out once all prompt commands (which constitute the bulk of
# extra DEBUG traps are done)
function reset_relink_done {
    RELINK_DONE=0
}

if [[ -n "$TMUX" ]]; then
    trap relink_sock DEBUG
    PROMPT_COMMAND="$PROMPT_COMMAND; reset_relink_done"
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
