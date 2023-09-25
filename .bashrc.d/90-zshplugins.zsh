# https://github.zshell.dev/docs/zsh/Zsh-Plugin-Standard.html#_what_is_a_zsh_plugin

load_plugins() {
  local initfile
  for plugin in $HOME/.zsh/plugin/*; do
    rc_debug "Loading plugin $plugin"
    fpath+=$plugin
    initfile=($plugin/*.plugin.zsh)
    (( $+functions[zsh-defer] )) && zsh-defer . $initfile || . $initfile
  done
}

if [[ "$RC_NOPLUGIN" != 1 ]]; then
  load_plugins
else
  rc_log "Not loading plugins"
fi

unset -f load_plugins
