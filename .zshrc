RC_DEBUG=0
RC_CACHING=1
RC_PLUGIN=1

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

main
uninit
unset RC_DEBUG RC_NOPLUGIN

# vim: foldmethod=marker foldlevel=0
