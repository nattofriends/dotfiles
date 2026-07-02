RC_DEBUG=0
RC_CACHING=1
RC_PLUGIN=1
RC_PLUGIN_DISABLE=""

noninteractive () {
    RC_DEBUG=0
    source_file ~/.zshenv.pre
    source_dir ~/.bashrc.d/noninteractive
    source_file ~/.zshenv.local
}

main () {
    rc_log "using zsh"
    rc_debug "RC_DEBUG=$RC_DEBUG"

    # Let's copy grml's naming convention on this, which seems to be reasonable
    source_file ~/.zshrc.pre
    source_file ~/.zshrc_prelocal # old

    source_dir ~/.bashrc.d/pre

    source_dir ~/.bashrc.d

    source_file ~/.zshrc.local
    source_file ~/.zshrc_local

    source_dir ~/.bashrc.d/post
}

for lib in ~/.bashrc.d/lib/lib.{sh,zsh}; do
    . $lib
done

if [[ $- != *i* ]] ; then
    noninteractive
else
    main
fi

uninit
unset RC_DEBUG RC_CACHING RC_PLUGIN main noninteractive

# vim: foldmethod=marker foldlevel=0
