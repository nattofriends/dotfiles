if command -v git >/dev/null; then
  function git_branch {
    local toplevel=$(git rev-parse --show-toplevel 2>/dev/null)

    if [[ $? -eq 128 ]]; then
      return
    fi

    if [[ $HOME != $toplevel ]]; then
      printf "("
      (git symbolic-ref --short HEAD 2>/dev/null || (printf "detached at %s" $(git rev-parse --short HEAD)))
      printf ") "
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

function envinstall {
  echo -e "/.env\n/.envrc" >> .git/info/exclude
  touch .env
  ln -s ~/.envrc.d/.envrc .envrc || true
}

function dc {
  if [[ -d "$1" ]]; then
    cd "$1"
  else
    command dc "$@"
  fi
}
