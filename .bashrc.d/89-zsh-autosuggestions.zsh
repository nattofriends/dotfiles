ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HISTORY_IGNORE="cd *"
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
ZSH_AUTOSUGGEST_IGNORE_WIDGETS+=(expand-or-complete)

# Double tab to accept autosuggest
zle -la autosuggest-accept && \
    bindkey '^I^I' autosuggest-accept
