if command -v kubectl >/dev/null; then
    rc_debug "enabling kubectl"
    kubectl completion zsh > generated/_kubectl
fi
