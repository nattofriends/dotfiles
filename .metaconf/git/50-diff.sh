configure_diff() {
    local git_version=$(git --version | grep -o '[[:digit:]].*[[:digit:]]')

    # https://github.com/Wilfred/difftastic/issues/917
    # ???
    # if command -v difft >/dev/null; then
    #     rc_debug "enabling difftastic"
    #     cat difftastic-config >> generated/config
    #     cat difftastic-attributes >> generated/attributes
    # fi

    # https://tekin.co.uk/2020/10/better-git-diff-output-for-ruby-python-elixir-and-more
    cat builtin-hunkheaders-attributes >> generated/attributes

    if $(compare_version 2.35.999 $git_version); then
        cat builtin-hunkheaders-2-36-attributes >> generated/attributes
    fi

    if command -v lockdiff >/dev/null; then
        rc_debug "enabling lockdiff"
        cat lockdiff-attributes >> generated/attributes

        # https://stackoverflow.com/a/72339133, gets confused for git < 2.37
        if $(compare_version 2.36.999 $git_version); then
            rc_debug "using direct lockdiff"
            cat lockdiff-config >> generated/config
        else
            rc_debug "using lockdiff with shim"
            cat lockdiff-shim-config >> generated/config
        fi
    fi

    # Doesn't know how to do side-by-side diffs?
    # if command -v diffr >/dev/null; then
    #     rc_debug "enabling diffr"
    #     cat diff-generic-config | sed s~DIFF_TOOL~diffr~ >> generated/config
    if command -v delta >/dev/null; then
        rc_debug "enabling delta"
        cat delta-config >> generated/config
    elif [ -f /opt/homebrew/opt/git/share/git-core/contrib/diff-highlight/diff-highlight ]; then
        rc_debug "enabling diff-highlight (system homebrew)"
        cat diff-generic-config | sed s~DIFF_TOOL~perl /opt/homebrew/opt/git/share/git-core/contrib/diff-highlight/diff-highlight~ >> generated/config
    elif [ -d /usr/share/doc/git/contrib/diff-highlight ]; then
        # Thanks Debian for not shipping diff-highlight in a usable form
        rc_debug "enabling diff-highlight (debian)"
        cat /usr/share/doc/git/contrib/diff-highlight/{DiffHighlight.pm,diff-highlight.perl} > generated/diff-highlight
        chmod +x generated/diff-highlight
        local abs=$(readlink -f generated/diff-highlight)
        cat diff-generic-config | sed "s~DIFF_TOOL~perl ${abs}~" >> generated/config
    fi

}

configure_diff
unset configure_diff
