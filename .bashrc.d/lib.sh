# Common functions for base .bashrc/.zshrc, not sourced in order

rc_warn () {
    >&2 printf "\033[1;31mWARNING: $1\033[0m\n"
}

rc_log () {
    >&2 printf "\033[1;33m$1\033[0m\n"
}

rc_debug () {
    if [[ $RC_DEBUG -eq 1 ]]; then
        rc_log "$1"
    fi
}

compare_version () {
    # true/success if $1 is lower than $2
    printf '%s\n%s' "$1" "$2" | sort -C -V
}

uninit () {
    # Letting compare_version hang around
    unset rc_log rc_debug source_file uninit
}

# vim: ft=sh
