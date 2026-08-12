# https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html#Prompt-Expansion

autoload -Uz add-zsh-hook

for _git in /opt/homebrew/bin/git /usr/bin/git; do
  [[ -x $_git ]] && break
done

_git_prompt=""
typeset -gA _git_prompt_toplevel_cache

_git_prompt_precmd() {
  local git_root
  if (( ${+_git_prompt_toplevel_cache[$PWD]} )); then
    git_root=${_git_prompt_toplevel_cache[$PWD]}
  else
    git_root=$($_git rev-parse --show-toplevel 2>/dev/null)
    _git_prompt_toplevel_cache[$PWD]=$git_root
  fi
  [[ -z "$git_root" || "$git_root" == "$HOME" ]] && { _git_prompt=""; return; }

  # In a worktree, .git is a file containing "gitdir: <path>" pointing to the
  # worktree-specific git dir (e.g. main/.git/worktrees/name). Resolving it
  # gives the correct HEAD and action state for this worktree.
  local git_dir=${git_root}/.git
  if [[ -f "$git_dir" ]]; then
    git_dir=$(<"$git_dir")
    git_dir=${git_dir#gitdir: }
  fi

  # Read HEAD directly to avoid forking git for branch detection.
  local branch
  local head=$(<"$git_dir/HEAD")
  if [[ "$head" == ref:\ * ]]; then
    branch=${head#ref: refs/heads/}
  else
    branch="detached"
  fi

  if [[ -d "$git_dir/rebase-merge" || -d "$git_dir/rebase-apply" ]]; then
    _git_prompt="($branch|rebase) "
  elif [[ -f "$git_dir/MERGE_HEAD" ]]; then
    _git_prompt="($branch|merge) "
  elif [[ -f "$git_dir/CHERRY_PICK_HEAD" ]]; then
    _git_prompt="($branch|cherry-pick) "
  else
    _git_prompt="($branch) "
  fi
}

add-zsh-hook precmd _git_prompt_precmd

setopt PROMPT_SUBST

PS1='%b[%D{%m/%d %R:%S}] %B%~ ${_git_prompt}%(!.#.$)%{%f%b%} '
