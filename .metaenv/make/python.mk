PIP_INDEX_URL ?= https://pypi.org/simple/

export PIPX_HOME := ${HOME}/.pipx/pipx
export PIPX_BIN_DIR := ${HOME}/.pipx/bin
export USE_EMOJI := false

install: python
python3:
	command -v pipx && command -v $@ && set -x && while read i; do \
		[[ "$$i" != \#* ]] && sh -xc "pipx install --verbose --index-url=$(PIP_INDEX_URL) $$i"; \
		done < <(cat global/$@.txt local/$@.txt) || echo "prerequisite not installed, skipping $@"

upgrade: python3-upgrade
python3-upgrade:
	command -v pipx && command -v python3 && \
		pipx upgrade-all --verbose && \
		pipx list \
		|| echo "prerequisite not installed, skipping $@"

clean: python3-clean
python3-clean:
	rm -rf ${HOME}/.pipx

# Optional
pyenv-bootstrap:
	git clone https://github.com/pyenv/pyenv.git ${HOME}/.pyenv ||:
	cd ${HOME}/.pyenv && src/configure && make -C src

upgrade: pyenv-upgrade
pyenv-upgrade:
	[ -d ${HOME}/.pyenv ] && \
		cd ${HOME}/.pyenv && \
		git pull && \
		$(MAKE) pyenv-bootstrap || echo "prerequisite not installed, skipping $@"

clean: pyenv-clean
pyenv-clean:
	rm -rf ${HOME}/.pyenv
