# https://www.gnu.org/software/bash/manual/html_node/Controlling-the-Prompt.html
# Would be nice if we could use __git_ps1 and friends but this is fine for now...
# git_branch is defined in 10-function

if [[ "$EUID" == "0" ]]; then
    PROMPT_CHAR="#"
else
    PROMPT_CHAR="$"
fi

PS1='[\D{%m/%d %R:%S}] \[\033[1m\]\w $(git_branch)${PROMPT_CHAR} \[$(tput sgr0)\]'

# For macOS bash
export BASH_SILENCE_DEPRECATION_WARNING=1
