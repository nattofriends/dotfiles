update() {
  if [[ "$NO_UPDATE" -eq 1 ]]; then
    rc_debug "Not updating dotfiles (disabled)"
    return
  fi

  if [[ $RANDOM -ge 3276 ]]; then
    rc_debug "RNG did not select for dotfile update"
    return
  fi

  (
    (
    git --git-dir $HOME/.git --work-tree $HOME pull --no-edit;
    git --git-dir $HOME/.git --work-tree $HOME submodule update --init --recursive
    ) 2>&1 | /usr/bin/grep -v "Already up to date" &
  )
}

update && unset update
