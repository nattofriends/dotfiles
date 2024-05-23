rc_git() {
  if ! command -v git >/dev/null; then
    return
  fi

  git config core.pager >/dev/null
  if [ $? -eq 0 ]; then
    return
  fi

  # Not sh-compliant, but bash and zsh support it so we use a .sh file
  local possible=(
    # Debian
    /usr/share/doc/git/contrib/diff-highlight/diff-highlight
    # macOS Homebrew
    /opt/homebrew/opt/git/share/git-core/contrib/diff-highlight/diff-highlight
  )

  for item in ${possible[@]}; do
    if [ -f "$item" ]; then
      rc_log "Configuring git diff"
      git config --file ${HOME}/.gitconfig_local core.pager "perl $item | less"
      git config --file ${HOME}/.gitconfig_local interactive.difffilter "perl $item"
      break
    fi
  done

}

rc_git
unset rc_git
