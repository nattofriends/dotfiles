if command -v mergiraf >/dev/null; then
    rc_debug "enabling mergiraf"
    cat mergiraf-config >> generated/config
    cat mergiraf-attributes >> generated/attributes
fi
