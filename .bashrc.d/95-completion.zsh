if [[ -d ~/.metaconf/zsh-completions/generated ]]; then
    fpath+=(~/.metaconf/zsh-completions/generated)
fi

autoload -Uz compinit bashcompinit

if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
    compinit -u
else
    compinit -u -C
fi

bashcompinit

if [[ ! -d ~/.zsh/cache ]]; then
    mkdir -p ~/.zsh/cache
fi

# Shift-Tab
bindkey '^[[Z' reverse-menu-complete

zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion::complete:*' gain-privileges 1
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' menu select
zstyle ':completion:*:make:*:targets' call-command true
zstyle ':completion:*:*:make:*' tag-order 'targets'
setopt MENU_COMPLETE
setopt AUTO_LIST
setopt COMPLETE_IN_WORD
