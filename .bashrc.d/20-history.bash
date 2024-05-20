shopt -s cmdhist histappend histreedit histverify
HISTCONTROL=ignoreboth
HISTIGNORE='ls:bg:fg:history'
HISTSIZE=10000
HISTFILESIZE=10000
HISTTIMEFORMAT='%F %T '

export PROMPT_COMMAND="history -a; ${PROMPT_COMMAND}"

if command -v hstr >/dev/null; then
    rc_log "integrating hstr"
    export HSTR_CONFIG=hicolor,prompt-bottom,help-on-opposite-side
    export HSTR_PROMPT="> "
    _hstr () {
        hstr -- $READLINE_LINE
    }
    bind -x '"\C-r": "_hstr"'
else
    rc_log "hstr not found, not integrating"
fi
