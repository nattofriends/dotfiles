# https://github.zshell.dev/docs/zsh/Zsh-Plugin-Standard.html#_what_is_a_zsh_plugin

zcompile_many() {
  local f
  for f; do zcompare "$f"; done
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
    zcompile_many $plugin/{*.plugin.zsh,**/*.zsh} &!

    # TODO: define deferrable plugins
    # (( $+functions[zsh-defer] )) && zsh-defer . $initfile || . $initfile
  done
}

if [[ "$RC_PLUGIN" != 0 ]]; then
  load_plugins
else
  rc_log "Not loading plugins"
fi

unset -f load_plugins zcompile_many
