if command -v git >/dev/null; then
  function git_branch {
    local TOPLEVEL
    TOPLEVEL=$(git rev-parse --show-toplevel 2>/dev/null)
    local TOPLEVELRC=$?
    if [[ $TOPLEVELRC -eq 128 ]]; then
      return
    fi

    if [[ $HOME != $TOPLEVEL ]]; then
      echo -n '('
      (git symbolic-ref --short HEAD 2>/dev/null || (echo -n "detached at " ; git rev-parse --short HEAD)) | tr -d '\n'
      echo -n ') '
    fi
  }
else
  function git_branch {
    return
  }
fi

function pbcopy {
    printf "\033]52;c;$(base64 | tr -d '\r\n')\a"
}

function pathadd {
    [[ -d "$1" && ":$PATH:" != *":$1:"* ]] && PATH="${PATH}:$1"
}
