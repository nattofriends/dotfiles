RC_DEBUG=0

# Not interactive? Get out early
if [[ $- != *i* ]] ; then
    return
fi

main() {
    rc_log "Using bash"
    rc_debug "RC_DEBUG=$RC_DEBUG"

    local extglob_restore
    shopt -q extglob
    extglob_restore=$?
    shopt -s extglob

    source_file ~/.bashrc_prelocal
    source_dir ~/.bashrc.d/pre

    source_dir ~/.bashrc.d

    source_file ~/.bashrc_local
    source_dir ~/.bashrc.d/post

    if [[ "$extglob_restore" == "1" ]]; then
        # extglob was off. Need to restore
        rc_debug "Disabling extglob"
        shopt -u extglob
    fi
}

source_dir () {
    local dir=$1

    if [[ -d "$dir" ]]; then
        local files=$(echo "${dir}/*.@(sh|bash)")
        for i in $files; do
            if [ -r $i ]; then
                rc_debug "Sourcing $i"
                . $i
            fi
          done
        unset i
    else
        rc_debug "Directory $dir does not exist, not sourcing"
    fi
}

. ~/.bashrc.d/lib

main
unset RC_DEBUG
unset rc_log rc_log source_file source_dir main

# vim: foldmethod=marker foldlevel=0
