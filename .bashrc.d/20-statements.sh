if command -v vim >/dev/null; then
  export EDITOR=vim
else
  rc_log "vim not present, EDITOR=$EDITOR"
fi

# Disable flow control
stty ixany ixoff -ixon

export PIP_REQUIRE_VIRTUALENV=true

export npm_config_prefix='~/.npm-prefix'
