RC_DEBUG=0
RC_CACHING=1

noninteractive() {
    RC_DEBUG=0
    source_dir ~/.bashrc.d/noninteractive
}

main() {
    rc_log "using bash"
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

for lib in ~/.bashrc.d/lib/lib.{sh,bash}; do
    . $lib
done

if [[ $- != *i* ]] ; then
    noninteractive
else
    main
fi

uninit
unset RC_DEBUG RC_CACHING noninteractive main

# vim: foldmethod=marker foldlevel=0
