# https://www.soberkoder.com/better-zsh-history/
# https://unix.stackexchange.com/questions/389881/history-isnt-preserved-in-zsh

SAVEHIST=10000
HISTFILE=~/.zsh_history
HISTSIZE=10000
HISTFILESIZE=10000

setopt histignorespace
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt share_history

if command -v hstr >/dev/null; then
    export HSTR_CONFIG=hicolor,prompt-bottom,help-on-opposite-side
    export HSTR_PROMPT="$ "
    # https://unix.stackexchange.com/questions/373795/bindkey-to-execute-command-zsh
    _hstr () {
        zle -I
        # https://superuser.com/questions/1583506/read-plaintext-input-from-inside-zle-widget
        hstr -- $BUFFER < /dev/tty
        zle redisplay
    }
    zle -N _hstr
    bindkey "\C-r" _hstr
else
    rc_log "hstr not found, not integrating"
fi
