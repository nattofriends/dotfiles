configure_merge() {
    local version=$(git --version | grep -o '[[:digit:]].*[[:digit:]]')
    # feature added in git 2.35.0
    if $(compare_version 2.34.999 $version); then
        rc_debug "Using zdiff3"
        cat git-zdiff3-config >> generated/config
    else
        rc_debug "Using diff3"
        cat git-diff3-config >> generated/config
    fi
}

configure_merge
unset configure_merge
