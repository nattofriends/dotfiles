MAKEFLAGS += --jobs=4

.PHONY: all
all: cargo python3.8 python3.9 python3.10 brew npm

.PHONY: upgrade
upgrade: cargo-upgrade python3.8-upgrade python3.9-upgrade python3.10-upgrade brew-upgrade npm-upgrade

.PHONY: clean
clean: cargo-clean python-clean brew-clean npm-clean
	rm -rf bin

.PHONY: cargo
# https://nickgerace.dev/post/how-to-manage-rust-tools-and-applications/
cargo:
	command -v cargo && set -x && while read i; do \
		cargo install $$i; \
		done < cargo.txt || echo "prerequisite not installed, skipping"

.PHONY: cargo-upgrade
cargo-upgrade:
	command -v cargo && cargo install-update --all || echo "cargo not installed, skipping"

cargo-clean:
	rm -rf ${HOME}/.cargo

export PIPX_HOME := ${HOME}/.pipx/pipx
export PIPX_BIN_DIR := ${HOME}/.pipx/bin
export USE_EMOJI := false

.PHONY: python%
python%:
	command -v pipx && command -v $@ && set -x && while read i; do \
		pipx install --python $@ $$i; \
		done < $@.txt || echo "prerequisite not installed, skipping"

.PHONY: python%-upgrade
python%-upgrade:
	command -v pipx && command -v python$* && pipx upgrade-all || echo "prerequisite not installed, skipping"

.PHONY: python-clean
python-clean:
	rm -rf ${HOME}/.pipx

.PHONY: brew
brew:
	mkdir -p ${HOME}/.homebrew
	curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C ${HOME}/.homebrew
	${HOME}/.homebrew/bin/brew update --force
	${HOME}/.homebrew/bin/brew tap homebrew/core
	${HOME}/.homebrew/bin/brew tap homebrew/bundle
	${HOME}/.homebrew/bin/brew bundle

brew-upgrade:
	${HOME}/.homebrew/bin/brew bundle

.PHONY: brew-clean
brew-clean:
	rm -rf ${HOME}/.homebrew

.PHONY: npm
npm:
	command -v npm && set -x && while read i; do \
		npm install -g $$i; \
		done < $@.txt || echo "npm not installed, skipping"

.PHONY: npm-upgrade
npm-upgrade:
	command -v npm && npm upgrade -g || echo "npm not installed, skipping"

.PHONY: npm-clean
npm-clean:
	rm -rf ${HOME}/.npm-prefix

.PHONY: metapath
metapath:
	mkdir -p bin
	./metapath.py bin

-include Makefile.local
