bindkey -e
skip_global_compinit=1

# Defer system compdefs until the cached compinit in 95-completion.zsh has run.
typeset -ga deferred_compdef_args
compdef() {
    deferred_compdef_args+=("$@")
}
