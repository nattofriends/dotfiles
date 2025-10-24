export HOMEBREW_NO_AUTO_UPDATE := 1
export HOMEBREW_NO_INSTALL_FROM_API := 1
export HOMEBREW_BUNDLE_NO_LOCK := 1

UNAME := $(shell uname)

# To be used on Linux only
ifeq ($(UNAME),Linux)
export HOMEBREW_PREFIX := ${HOME}/.homebrew/bin

brew-bootstrap:
	mkdir -p ${HOME}/.homebrew
	git clone https://github.com/Homebrew/brew ${HOME}/.homebrew
	${HOME}/.homebrew/bin/brew tap homebrew/core --force
	${HOME}/.homebrew/bin/brew tap homebrew/bundle
	$(MAKE) brew-upgrade

clean: brew-clean
brew-clean:
	rm -rf ${HOME}/.homebrew

else ifeq ($(UNAME),Darwin)
brew-bootstrap:
	# Use default install method for macOS
	/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
endif

install: brew
brew: brew-upgrade
upgrade: brew-upgrade
brew-upgrade:
	command -v brew && \
		set -x; \
		(brew update ||: ); \
		brew bundle --verbose --file global/Brewfile; \
		(brew bundle --verbose --file local/Brewfile ||:);  \
		brew upgrade \
		|| echo "prerequisite not installed, skipping $@"
