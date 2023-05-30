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

if command -v tmux >/dev/null; then
  function ltmux {
    if tmux has-session -t 0; then
      tmux -u attach -t 0
    else
      tmux -u new
    fi
  }
else
  function ltmux {
    echo tmux is not installed
  }
fi

function pbcopy {
    printf "\033]52;c;$(head -c 74994 - | base64 | tr -d '\n\r')\a"
}

function pathcheck {
    [[ -d "$1" && ":$PATH:" != *":$1:"* ]]
}

function pathprepend {
    pathcheck "$1" && PATH="$1:${PATH}"
}

function pathappend {
    pathcheck "$1" && PATH="${PATH}:$1"
}
