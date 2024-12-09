# See also: pyenv bootstrap in metaenv
if [ -d $HOME/.pyenv ]; then
  pathappend $HOME/.pyenv/bin

  export PYENV_ROOT=$HOME/.pyenv
  eval "$(pyenv init -)"

  pyenv-install () {
    env PYTHON_CONFIGURE_OPTS='--enable-optimizations --with-lto' PYTHON_CFLAGS='-march=native -mtune=native' PROFILE_TASK='-m test.regrtest --pgo -j0' pyenv install --verbose "$@"
  }
fi
