if command -v difft >/dev/null; then
    rc_debug "enabling difftastic"
    cat difftastic-config >> generated/config
fi
# TODO: Configure diff-highlight
