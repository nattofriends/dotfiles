#!/usr/bin/env bash
# works poorly under zsh for some reason

RC_DEBUG=1

main () {
    pushd git >/dev/null
    rm generated/*
    local files=*.sh
    for i in $files; do
        if [ -r $i ]; then
            rc_debug "Sourcing $i"
            . $i
        fi
      done
    unset i
    popd >/dev/null
}

source $HOME/.bashrc.d/lib

main
