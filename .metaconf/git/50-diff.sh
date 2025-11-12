if command -v difft >/dev/null; then
    rc_debug "enabling difftastic"
    cat difftastic-config >> generated/config
fi

if command -v lockdiff >/dev/null; then
    rc_debug "enabling lockdiff"
    cat lockdiff-config >> generated/config
    cat lockdiff-attributes >> generated/attributes
fi

# TODO: Configure diff-highlight
