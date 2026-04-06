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
    if (( $+commands[atuin] )); then
        # Also see 89-zsh-autosuggestions.zsh
        rc_debug "integrating atuin"

        if [[ "$RC_CACHING" = 1 ]]; then
            local cachedir=~/.cache/.bashrc.d
            local cachefile=$cachedir/atuin.zsh

            if [[ -s "$cachefile.zwc" && ! "${commands[atuin]}" -nt "$cachefile.zwc" ]]; then
                rc_debug "atuin: using cached init"
                source "$cachefile"
                # use up key mode for another binding
                bindkey '^e' atuin-up-search
                return
            fi
        fi

        rc_debug "atuin: recreating init file"
        local init=$(atuin init zsh --disable-up-arrow)

        eval "$init"

        # use up key mode for another binding
        bindkey '^e' atuin-up-search

        if [[ "$RC_CACHING" = 1 ]]; then
            {
                [[ -d "$cachedir" ]] || mkdir -p "$cachedir"
                echo "$init" > $cachefile
                zcompile -U $cachefile
            } &!
        fi
    elif (( $+commands[hstr] )); then
        rc_debug "integrating hstr"
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

            # Force autosuggestions to refresh so the old ghost text doesn't hang around
            if (( $+functions[_zsh_autosuggest_fetch] )); then
                _zsh_autosuggest_fetch
            fi
            zle redisplay
        }
        zle -N _hstr
        bindkey "\C-r" _hstr
    fi
}

rc_history
unset rc_history
