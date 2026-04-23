# https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html#Prompt-Expansion

autoload -Uz vcs_info
autoload -Uz add-zsh-hook

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats '(%b) '
zstyle ':vcs_info:git:*' actionformats '(%b|%a) '

vcs_info_precmd() {
  local git_root=$(git rev-parse --show-toplevel 2>/dev/null)
  [[ -z "$git_root" ]] && { vcs_info_msg_0_=""; return; }

  if [[ "$git_root" == "$HOME" ]]; then
    vcs_info_msg_0_=""
    return
  fi

  vcs_info
}

add-zsh-hook precmd vcs_info_precmd

setopt PROMPT_SUBST

# No longer using git_branch
PS1='%b[%D{%m/%d %R:%S}] %B%~ ${vcs_info_msg_0_}%(!.#.$)%{%f%b%} '
