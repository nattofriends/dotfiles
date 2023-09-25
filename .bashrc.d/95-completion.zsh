bindkey -e

autoload -Uz compinit bashcompinit
compinit
bashcompinit

# Source system bash completions
# if [ -f /usr/share/bash-completion/bash_completion ]; then
#   . /usr/share/bash-completion/bash_completion
# elif [ -f /etc/bash_completion ]; then
#   . /etc/bash_completion
# fi

if [[ ! -d ~/.zsh/cache ]]; then
    mkdir -p ~/.zsh/cache &
    rc_log "Created ~/.zsh/cache"
fi

# Shift-Tab
bindkey '^[[Z' reverse-menu-complete

zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion::complete:*' gain-privileges 1
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' menu select
setopt MENU_COMPLETE
setopt AUTO_LIST
setopt COMPLETE_IN_WORD
