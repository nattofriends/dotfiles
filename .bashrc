# .bashrc everywhere

# Pre-hook (.bashrc_prelocal) {{{1
[[ -e "$HOME/.bashrc_prelocal" ]] && source $HOME/.bashrc_prelocal

# Not interactive? Get out early
if [[ $- != *i* ]] ; then
    return
fi

# Aliases {{{1
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
alias apt-dance='apt update; apt upgrade; apt autoremove; apt autoclean'

# Exports {{{1
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

# Terminal configuration {{{1

# So much overhead! It hurts!
if [[ -n "$(which git)" ]]; then
  function git_branch {
    local TOPLEVEL
    TOPLEVEL=$(git rev-parse --show-toplevel 2>/dev/null)
    local TOPLEVELRC=$?
    if [[ $TOPLEVELRC -eq 128 ]]; then
      return
    fi

    if [[ $HOME != $TOPLEVEL ]]; then
      echo -n '('
      (git symbolic-ref --short HEAD 2>/dev/null || (echo -n "detached at " ; git rev-parse --short HEAD)) | tr -d '\n'
      echo -n ') '
    fi
  }
else
  function git_branch {
    return
  }
fi

# Begone, colors!
PS1='[\D{%m/%d %R:%S}] \u \[$(tput bold)\]\w $(git_branch)$ \[$(tput sgr0)\]'

# Standard(tm) window titles
TILDE="~"
PROMPT_TITLE='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/${TILDE}}\007"'
PROMPT_COMMAND="history -a; $PROMPT_TITLE"

# Sockminder {{{1

# To enable, export ENABLE_SOCKMINDER=1 in .bashrc_prelocal.

# 1. Before every command, link .ssh/sock to the most recently active client.
function relink_sock {
    if [[ "$RELINK_DONE" == "1" ]]; then
        return
    fi

    if [[ "$_TMUX_SUPPORTS_CLIENT_PID" == "0" ]]; then
        sock=$(grep $(tmux list-clients -F "#{client_activity} #{client_tty}" | sort -r | head -n 1 | cut -d ' ' -f 2) < $TMPDIR/.sockminder.$USER | cut -d ' ' -f 2)
    else
        sock=$(grep -aPo '(?<=SSH_AUTH_SOCK=)[^\0]+' /proc/$(tmux list-clients -F "#{client_activity} #{client_pid}" | sort -r | head -n 1 | cut -d ' ' -f 2)/environ) 
    fi

    # Link the sock to the most recent client
    # If the client didn't have a SSH_AUTH_SOCK, this will be just empty.
    if [[ "$sock" != "" ]]; then
        ln -sf $sock ~/.ssh/sock
    fi

    RELINK_DONE=1
}

# 2. Clear the early return out once all prompt commands (which constitute the bulk of
# extra DEBUG traps are done)
function reset_relink_done {
    RELINK_DONE=0
}

# Cleanup function when using the file method
function clean_sockminder {
    # Remove disconnected clients from the sockminder
    SOCKMINDER=$TMPDIR/.sockminder.$USER
    (grep -P $(who | sed -r "/^$USER/! d; s/.*(pts\/[[:digit:]]+).*/\1/" | paste -sd '|') $SOCKMINDER > $SOCKMINDER.tmp && mv $SOCKMINDER.tmp $SOCKMINDER) & disown
}

function write_sockminder {
    SOCKMINDER=$TMPDIR/.sockminder.$USER
    sort -u <(grep -v $(tty) $SOCKMINDER) <(echo $(tty) $SSH_AUTH_SOCK) > $SOCKMINDER.tmp && mv $SOCKMINDER.tmp $SOCKMINDER
    clean_sockminder
}

[ -n $(which tmux) -a $(tmux -V | tr -dc '0-9') -le 20 ]
_TMUX_SUPPORTS_CLIENT_PID=$?

[ -e "/proc" ]
_SYSTEM_SUPPORTS_PROCFS=$?

if [[ "$ENABLE_SOCKMINDER" == "1" ]]; then
    if [[ -n "$TMUX" ]]; then
        trap relink_sock DEBUG
        PROMPT_COMMAND="$PROMPT_COMMAND; reset_relink_done"
    else
        if [[ "$_TMUX_SUPPORTS_CLIENT_PID" == "0" ]]; then
            echo "Warning: tmux too old to support sock relinking using client_pid method, using file method"
            write_sockminder
        elif [[ "$_SYSTEM_SUPPORTS_PROCFS" == "1" ]]; then
            echo "Warning: system does not support procfs (/proc), using file method"
            write_sockminder
        fi
    fi
else
    # Fallback to last-login-wins
    if [[ -z "$TMUX" && -n "$SSH_AUTH_SOCK" ]]; then
        ln -sf $SSH_AUTH_SOCK ~/.ssh/sock
    fi
fi

# Misc {{{1
# Multi-terminal history
shopt -s cmdhist
shopt -s histappend
shopt -s histreedit
shopt -s histverify
HISTCONTROL=ignoreboth
HISTFILESIZE=1000000
HISTIGNORE='ls:bg:fg:history'
HISTSIZE=10000
HISTTIMEFORMAT='%F %T '

# Disable flow control
stty ixany
stty ixoff -ixon

# Try to automatically update 10% of the time
if [[ "$NO_UPDATE" != "1" && $RANDOM -lt 3276 ]]; then
    git --git-dir $HOME/.git --work-tree $HOME pull --no-edit
    git --git-dir $HOME/.git --work-tree $HOME submodule update --init --recursive
fi

# Source .bashrc_local {{{1
[[ -e "$HOME/.bashrc_local" ]] && source $HOME/.bashrc_local

# vim: foldmethod=marker foldlevel=0
