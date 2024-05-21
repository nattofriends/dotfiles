# These are controlled by .inputrc when using bash

# Reset to Emacs mode, which is way more popular and normal for shells
bindkey -e

# Make macOS Home and End keys work through SSH
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line
# and locally (???)
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

# https://stackoverflow.com/questions/890620/unable-to-have-bash-like-c-x-e-in-zsh
autoload edit-command-line
zle -N edit-command-line

_edit-command-line () {
    zle edit-command-line
    zle redisplay
}

zle -N _edit-command-line

bindkey '^X^e' _edit-command-line
