zcompile_bg() {
    setopt EXTENDED_GLOB

    # zcompile the completion cache; siginificant speedup.
    for file in ${ZDOTDIR:-${HOME}}/.zcomp^(*.zwc)(.N); do
      zcompare ${file}
    done

    # zcompile .zshrc
    zcompare ${ZDOTDIR:-${HOME}}/.zshrc
}

zcompile_bg &!
unset zcompile_bg
