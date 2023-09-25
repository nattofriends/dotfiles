# https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html#Prompt-Expansion

setopt PROMPT_SUBST
# Would be nice if we could use __git_ps1 and friends but this is fine for now...
# git_branch is defined in 10-function

if [[ "$EUID" == "0" ]]; then
    PROMPT_CHAR="#"
else
    PROMPT_CHAR="$"
fi

PS1='[%D{%m/%d %R:%S}] %B%~ $(git_branch)${PROMPT_CHAR} %b'

# Reset to Emacs mode, which is way more popular and normal for shells
bindkey -e

# Make macOS Home and End keys work through SSH
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line
# and locally (???)
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HISTORY_IGNORE="cd *"
