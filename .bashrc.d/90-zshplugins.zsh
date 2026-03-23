# https://github.zshell.dev/docs/zsh/Zsh-Plugin-Standard.html#_what_is_a_zsh_plugin

zcompile_many() {
  local f
  for f; do zcompile -R -- "$f".zwc "$f"; done
}

load_plugins() {
  local initfile
  for plugin in $HOME/.zsh/plugin/*; do
    rc_debug "Loading plugin $plugin"
    fpath+=$plugin
    initfile=($plugin/*.plugin.zsh)
    . $initfile
    zcompile_many $plugin/{*.plugin.zsh,**/*.zsh}
    # (( $+functions[zsh-defer] )) && zsh-defer . $initfile || . $initfile
  done

  (
    # Function to determine the need of a zcompile. If the .zwc file
    # does not exist, or the base file is newer, we need to compile.
    # These jobs are asynchronous, and will not impact the interactive shell
    zcompare() {
      if [[ -s ${1} && ( ! -s ${1}.zwc || ${1} -nt ${1}.zwc) ]]; then
        zcompile ${1}
      fi
    }

    setopt EXTENDED_GLOB

    # zcompile the completion cache; siginificant speedup.
    for file in ${ZDOTDIR:-${HOME}}/.zcomp^(*.zwc)(.); do
      zcompare ${file}
    done

    # zcompile .zshrc
    zcompare ${ZDOTDIR:-${HOME}}/.zshrc

  ) &!
}

if [[ "$RC_PLUGIN" != 0 ]]; then
  load_plugins
else
  rc_log "Not loading plugins"
fi

unset -f load_plugins zcompile_many
