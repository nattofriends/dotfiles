RC_DEBUG=0

# Not interactive? Get out early
if [[ $- != *i* ]] ; then
    return
fi

main() {
    rc_log "Using bash"
    rc_debug "RC_DEBUG=$RC_DEBUG"

    source_file ~/.bashrc_prelocal
    source_dir ~/.bashrc.d/pre

    source_dir ~/.bashrc.d

    source_file ~/.bashrc_local
    source_dir ~/.bashrc.d/post
}

source_dir () {
    local dir=$1
    shopt -s extglob

    if [[ -d "$dir" ]]; then
        local files=$(echo "${dir}/*.@(sh|bash)")
        for i in $files; do
            if [ -r $i ]; then
                rc_debug "Sourcing $i"
                . $i
            fi
          done
        unset i
    fi

    shopt -u extglob
}

. .bashrc.d/lib

main
unset RC_DEBUG
unset rc_log rc_log source_file source_dir main

# vim: foldmethod=marker foldlevel=0
