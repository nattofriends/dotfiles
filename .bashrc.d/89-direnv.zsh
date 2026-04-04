configure_direnv() {
    if (( ! $+commands[direnv] )); then
        return
    fi

    if [[ "$RC_CACHING" = 1 ]]; then
        local cachedir=~/.cache/.bashrc.d
        local cachefile=$cachedir/direnv.zsh

        if [[ -s "$cachefile.zwc" && ! "${commands[direnv]}" -nt "$cachefile.zwc" ]]; then
            rc_debug "direnv: using cached init"
            source "$cachefile"
            return
        fi
    fi

    local init=$(direnv hook zsh)
    eval "$init"

    if [[ "$RC_CACHING" = 1 ]]; then
        {
            [[ -d "$cachedir" ]] || mkdir -p "$cachedir"
            echo "$init" > $cachefile
            zcompile -U $cachefile
        } &!
    fi
}

configure_direnv
unset configure_direnv
