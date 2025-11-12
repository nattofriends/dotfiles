if [[ -f generated/attributes ]]; then
    rc_debug "Linking attributes file"
    ln -sf $(readlink -f generated/attributes) ~/.gitattributes_global
fi
