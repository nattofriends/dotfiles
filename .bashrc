# .bashrc everywhere

# Not interactive? Get out early
if [[ $- != *i* ]] ; then
    return
fi

# Source pre-hook (.bashrc_prelocal) {{{1
[[ -f "$HOME/.bashrc_prelocal" ]] && . ~/.bashrc_prelocal

# Source parts
if [[ -d ~/.bashrc.d ]]; then
  for i in ~/.bashrc.d/*.sh; do
    if [ -r $i ]; then
      . $i
    fi
  done
  unset i
fi

# Try to automatically update 10% of the time
if [[ "$NO_UPDATE" != "1" && $RANDOM -lt 3276 ]]; then
    git --git-dir $HOME/.git --work-tree $HOME pull --no-edit
    (git --git-dir $HOME/.git --work-tree $HOME submodule update --init --recursive &)
fi

# Source .bashrc_local {{{1
[[ -e "$HOME/.bashrc_local" ]] && source $HOME/.bashrc_local

# vim: foldmethod=marker foldlevel=0
