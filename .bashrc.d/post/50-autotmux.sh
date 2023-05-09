if command -v tmux >/dev/null \
  && [ -z "$TMUX" ] \
  && [ -e "$HOME/.autotmux" ]; then
    if tmux has-session -t 0; then
      exec tmux -u attach -t 0
    else
      exec tmux -u new
  fi
fi
