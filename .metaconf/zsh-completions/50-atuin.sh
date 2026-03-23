if command -v atuin >/dev/null; then
    rc_debug "enabling atuin"
    atuin gen-completions --shell zsh --out-dir generated
fi
