RC_DEBUG=0
RC_CACHING=1
RC_PLUGIN=1

noninteractive() {
    RC_DEBUG=0
    source_dir ~/.bashrc.d/noninteractive
}

main() {
    rc_log "Using zsh"
    rc_debug "RC_DEBUG=$RC_DEBUG"

    source_file ~/.zshrc_prelocal
    source_dir ~/.bashrc.d/pre

    source_dir ~/.bashrc.d

    source_file ~/.zshrc_local
    source_dir ~/.bashrc.d/post
}

source_dir () {
    local dir=$1

    if [[ -d "$dir" ]]; then
        for i in $dir/*.(zsh|sh); do
            if [ -r $i ]; then
                rc_debug "Sourcing $i"
                . $i
            fi
          done
        unset i
    fi
}

. ~/.bashrc.d/lib

if [[ $- != *i* ]] ; then
    noninteractive
else
    main
fi

uninit
unset RC_DEBUG RC_CACHING RC_PLUGIN main noninteractive

# vim: foldmethod=marker foldlevel=0
