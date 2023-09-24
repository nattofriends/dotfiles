if command -v vim >/dev/null; then
  export EDITOR=vim
else
  rc_log "vim not present, EDITOR=$EDITOR"
fi

# Disable flow control
stty ixany ixoff -ixon

# Enable readline and history for Python interactive
export PYTHONSTARTUP=~/.pythonrc.py

export npm_config_prefix='~/.npm-prefix'

pathprepend $HOME/.metaenv/bin
