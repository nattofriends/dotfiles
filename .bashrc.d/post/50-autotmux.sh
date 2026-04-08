if command -v tmux >/dev/null \
  && [ -z "$TMUX" ] \
  && [ -e "$HOME/.autotmux" ]; then
    if tmux has-session -t 0; then
      tmux -u attach -t 0
    else
      tmux -u new
  fi
  rc_log "this computer is still ${HOST:-${HOSTNAME}}"
fi
