configure_less () {
    if [[ "$RC_CACHING" = 1 ]]; then
        local cachedir=~/.cache/.bashrc.d
        local cachefile=$cachedir/less.sh
        [[ -d "$cachedir" ]] || mkdir -p "$cachedir"

        if [[ -s "$cachefile" ]]; then
            rc_debug "less: using cached configuration"
            source $cachefile
            return
        fi
    fi

    # https://stackoverflow.com/a/42056714/
    # https://unix.stackexchange.com/questions/184597/
    local less="-XRF --mouse"

    local version=$(less --version | head -n 1 | grep -Eo "[[:digit:]].*[[:digit:]]")
    rc_debug "less: version is ${version}"

    # feature added in less 574
    if $(compare_version 574 $version); then
        rc_debug "less: enabling --incsearch"
        less="${less} --incsearch"
    fi
    export LESS=$less

    if [[ "$RC_CACHING" = 1 ]]; then
        ( (
            [[ -d "$cachedir" ]] || mkdir -p "$cachedir"
            echo "export LESS='${less}'" > $cachefile
            if command -v zcompile >/dev/null; then
                zcompile -U $cachefile
            fi
            ) & )
    fi
}

configure_less
unset configure_less
