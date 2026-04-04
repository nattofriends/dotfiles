#!/usr/bin/env bash
# works poorly under zsh for some reason

RC_DEBUG=1

main () {
    pushd git >/dev/null
    rm -f generated/*
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

for lib in $HOME/.bashrc.d/lib/lib.{sh,bash}; do
    source $lib
done

main
