# This doesn't check if a system has grep. I hope all systems have grep

configure_grep () {
    # Bold white on red
    local -r HIGHLIGHT_COLOR='01;97;41'

    if [[ "$RC_CACHING" = 1 ]]; then
        local cachedir=~/.cache/.bashrc.d
        local cachefile=$cachedir/grep.sh

        if [[ -s "$cachefile" ]]; then
            rc_debug "grep: using cached configuration"
            source $cachefile
            wrap_grep
            return
        fi
    fi

    local version=$(grep --version | head -n 1)
    rc_debug "grep: version is ${version}"
    local colors=""

    case "$version" in
        *"BSD grep"*)
            rc_debug "grep: configuring for BSD grep"
            colors="export GREP_COLOR='${HIGHLIGHT_COLOR}'"
            ;;
        *"GNU grep"*)
            # Turns out that GNU grep still supports GREP_COLOR, but warns you every time about it
            rc_debug "grep: configuring for GNU grep"
            colors="export GREP_COLORS='ms=${HIGHLIGHT_COLOR}'"
            ;;
        *)
            rc_warn "Don't know how to configure grep '${version}'"
            ;;
    esac

    if [[ "${colors}" != "" ]] && [[ "$RC_CACHING" = 1 ]]; then
        ( (
            [[ -d "$cachedir" ]] || mkdir -p "$cachedir"
            eval "${colors}"
            echo $colors > $cachefile
            if command -v zcompile >/dev/null; then
                zcompile -U $cachefile
            fi
        ) & )
    fi

    wrap_grep
}

wrap_grep () {
    _grep_path=$(command -v grep 2>&1)
    declare -r _grep_path

    grep () {
        "${_grep_path}" --color=auto "$@"
    }
}

configure_grep
unset configure_grep wrap_grep
