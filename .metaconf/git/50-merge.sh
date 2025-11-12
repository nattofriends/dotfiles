compare_version() {
    printf '%s\n%s' "$1" "$2" | sort -C -V
}

configure_merge() {
    local version=$(git --version | grep -o "\d.*\d")
    # feature added in git 2.5.5
    if $(compare_version 2.5.4 $version); then
        rc_debug "Using zdiff3"
        cat git-zdiff3-config >> generated/config
    else
        rc_debug "Using diff3"
        cat git-diff3-config >> generated/config
    fi
}

configure_merge

unset configure_merge compare_version
