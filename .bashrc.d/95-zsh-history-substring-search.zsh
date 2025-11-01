# If the plugin isn't present, don't trample on the builtin bindings

zle -la history-substring-search-up && \
    bindkey '^[[A' history-substring-search-up

zle -la history-substring-search-down && \
    bindkey '^[[B' history-substring-search-down
