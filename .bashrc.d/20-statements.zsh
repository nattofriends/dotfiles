# https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html#Prompt-Expansion

setopt PROMPT_SUBST
# Would be nice if we could use __git_ps1 and friends but this is fine for now...
# git_branch is defined in 10-function

PS1='[%D{%m/%d %R:%S}] %B%~ $(git_branch)%(!.#.$) %b'
