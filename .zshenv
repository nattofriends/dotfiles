noninteractive () {
    RC_DEBUG=0
    source_file ~/.zshenv.pre
    source_dir ~/.bashrc.d/noninteractive
    source_file ~/.zshenv.local
}

for lib in ~/.bashrc.d/lib/lib.{sh,zsh}; do
    . $lib
done

noninteractive

uninit
unset RC_PLUGIN noninteractive

# vim: foldmethod=marker foldlevel=0
