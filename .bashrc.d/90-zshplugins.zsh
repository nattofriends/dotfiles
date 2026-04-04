# https://github.zshell.dev/docs/zsh/Zsh-Plugin-Standard.html#_what_is_a_zsh_plugin

zcompile_many() {
  local f
  for f; do zcompile -R -- "$f".zwc "$f"; done
}

load_plugins() {
  local initfile
  for plugin in $HOME/.zsh/plugin/*(N); do
    if [[ "$RC_PLUGIN_DISABLE" == *"${plugin:t}"* ]]; then
      rc_debug "Plugin ${plugin:t} disabled - not loading"
      continue
    fi

    rc_debug "Loading plugin $plugin"
    fpath+=$plugin
    initfile=($plugin/*.plugin.zsh)
    . $initfile
    zcompile_many $plugin/{*.plugin.zsh,**/*.zsh}
    # (( $+functions[zsh-defer] )) && zsh-defer . $initfile || . $initfile
  done

  (
    setopt EXTENDED_GLOB

    # zcompile the completion cache; siginificant speedup.
    for file in ${ZDOTDIR:-${HOME}}/.zcomp^(*.zwc)(.N); do
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
