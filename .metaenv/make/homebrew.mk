export HOMEBREW_NO_AUTO_UPDATE := 1
export HOMEBREW_NO_INSTALL_FROM_API := 1
export HOMEBREW_BUNDLE_NO_LOCK := 1

# To be used on Linux only
ifeq ($(shell uname),Linux)
export HOMEBREW_PREFIX := ${HOME}/.homebrew/bin

brew-bootstrap:
	mkdir -p ${HOME}/.homebrew
	curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C ${HOME}/.homebrew
	${HOME}/.homebrew/bin/brew tap homebrew/core --force
	${HOME}/.homebrew/bin/brew tap homebrew/bundle
	$(MAKE) brew-upgrade

clean: brew-clean
brew-clean:
	rm -rf ${HOME}/.homebrew
endif

upgrade: brew-upgrade
brew-upgrade:
	-brew update
	brew bundle --verbose --file global/Brewfile
	-brew bundle --verbose --file local/Brewfile
