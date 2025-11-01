export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
export ZSH_AUTOSUGGEST_HISTORY_IGNORE="cd *"
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
export ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Double tab to accept autosuggest
zle -la autosuggest-accept && \
    bindkey '^I^I' autosuggest-accept
