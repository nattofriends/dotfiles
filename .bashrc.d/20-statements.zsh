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
