configure_brew_dynamic () {
    if (( ! $+commands[brew] )); then
        return
    fi

    if [[ "$RC_CACHING" = 1 ]]; then
        local cachedir=~/.cache/.bashrc.d
        local cachefile=$cachedir/brew.zsh
        [[ -d "$cachedir" ]] || mkdir -p "$cachedir"

        if [[ -s "$cachefile.zwc" ]]; then
            rc_debug "brew: using cached configuration"
            source $cachefile
            return
        fi
    fi

    local init=$(brew shellenv)
    eval "$init"

    if [[ "$RC_CACHING" = 1 ]]; then
        {
            [[ -d "$cachedir" ]] || mkdir -p "$cachedir"
            echo "$init" > $cachefile
            zcompile -U $cachefile
        } &!
    fi
}

configure_brew_static () {
    if (( ! $+commands[brew] )); then
        return
    fi

    export HOMEBREW_PREFIX="/opt/homebrew";
    export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
    export HOMEBREW_REPOSITORY="/opt/homebrew";
    fpath[1,0]="/opt/homebrew/share/zsh/site-functions";
    [ -z "${MANPATH-}" ] || export MANPATH=":${MANPATH#:}";
    export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";

    pathprepend /opt/homebrew/bin
    pathprepend /opt/homebrew/sbin
}

configure_brew_static
unset configure_brew_dynamic configure_brew_static
