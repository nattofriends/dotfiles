configure_diff() {
    if command -v difft >/dev/null; then
        rc_debug "enabling difftastic"
        cat difftastic-config >> generated/config
    fi

    if command -v lockdiff >/dev/null; then
        rc_debug "enabling lockdiff"
        cat lockdiff-attributes >> generated/attributes

        local git_version=$(git --version | grep -o '[[:digit:]].*[[:digit:]]')
        # https://stackoverflow.com/a/72339133, gets confused for git < 2.37
        if $(compare_version 2.36.999 $git_version); then
            rc_debug "Using direct lockdiff"
            cat lockdiff-config >> generated/config
        else
            rc_debug "Using lockdiff with shim"
            cat lockdiff-shim-config >> generated/config
        fi
    fi

    # TODO: Configure diff-highlight
}

configure_diff
unset configure_diff
