if [[ -d ~/.metaconf/zsh-completions/generated ]]; then
    fpath+=(~/.metaconf/zsh-completions/generated)
fi

autoload -Uz compinit bashcompinit

for dump in ~/.zcompdump(N.mh+24); do
    compinit -u
done

compinit -C

mkdir -p ~/.zsh/cache

# Shift-Tab
bindkey '^[[Z' reverse-menu-complete

# Visual
# Enable menu
zstyle ':completion:*' menu select
# Colorize
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS} ""
# Group items
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%B%F{yellow}-- %d --%f%b'
zstyle ':completion:*' select-prompt %S%p%s
zstyle ':completion:*:warnings' format '%F{red}no matches for:%f %d'

# Matching
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion::complete:*' gain-privileges 1
zstyle ':completion:*' squeeze-slashes true
# Case insensitive and fuzzy
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}' '+r:|[_-]=* r:|=*' '+l:|=*'
# Completion order
zstyle ':completion:*' completer _expand _complete _approximate
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# make: only show targets
zstyle ':completion:*:make:*:targets' call-command true
zstyle ':completion:*:*:make:*' tag-order 'targets'

# git
zstyle ':completion:*:*:git:*' factor 0.1

setopt MENU_COMPLETE
setopt AUTO_LIST
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END
