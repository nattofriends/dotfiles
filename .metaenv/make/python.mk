export PIPX_HOME := ${HOME}/.pipx/pipx
export PIPX_BIN_DIR := ${HOME}/.pipx/bin
export USE_EMOJI := false

install: python
python3:
	command -v pipx && command -v $@ && set -x && while read i; do \
		[[ "$$i" != \#* ]] && sh -xc "pipx install --verbose --index-url=https://pypi.org/simple/ $$i"; \
		done < <(cat global/$@.txt local/$@.txt) || echo "prerequisite not installed, skipping"

upgrade: python3-upgrade
python3-upgrade:
	command -v pipx && command -v python3 && \
		pipx upgrade-all --verbose && \
		pipx list --short \
		|| echo "prerequisite not installed, skipping"

clean: python3-clean
python3-clean:
	rm -rf ${HOME}/.pipx

# Optional
pyenv-bootstrap:
	git clone https://github.com/pyenv/pyenv.git ${HOME}/.pyenv ||:
	cd ${HOME}/.pyenv && src/configure && make -C src

pyenv-upgrade: pyenv-bootstrap

clean: pyenv-clean
pyenv-clean:
	rm -rf ${HOME}/.pyenv
