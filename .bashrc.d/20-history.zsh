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

rc_history() {
    if command -v atuin >/dev/null; then
        rc_log "integrating atuin"
        eval "$(atuin init zsh --disable-up-arrow)"
        return
    else
        rc_log "atuin not found, not integrating"
    fi

    if command -v hstr >/dev/null; then
        rc_log "integrating hstr"
        export HSTR_CONFIG=hicolor,prompt-bottom,help-on-opposite-side
        export HSTR_PROMPT="> "
        # https://unix.stackexchange.com/questions/373795/bindkey-to-execute-command-zsh
        _hstr () {
            zle -I
            # https://superuser.com/questions/1583506/read-plaintext-input-from-inside-zle-widget
            # XXX: We can either preserve the BUFFER when Esc exiting from hstr, or avoid duplicating it in edit mode
            # No-TIOCSTI should give more control but hstr seems to ignore HSTR_NO_TIOCSTI?
            hstr -- ${=BUFFER} < /dev/tty
            BUFFER=
            # There is also some strange interaction with zsh-autosuggestions when Esc-exiting
            # This helps a little for some reason
            # zle recursive-edit
        }
        zle -N _hstr
        bindkey "\C-r" _hstr
    else
        rc_log "hstr not found, not integrating"
    fi
}

rc_history
unset rc_history
