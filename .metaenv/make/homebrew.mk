export HOMEBREW_PREFIX := ${HOME}/.homebrew/bin
export HOMEBREW_NO_AUTO_UPDATE := 1
export HOMEBREW_NO_INSTALL_FROM_API := 1
export HOMEBREW_BUNDLE_NO_LOCK := 1

install: brew
brew:
	mkdir -p ${HOME}/.homebrew
	curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C ${HOME}/.homebrew
	${HOME}/.homebrew/bin/brew tap homebrew/core --force
	${HOME}/.homebrew/bin/brew tap homebrew/bundle
	$(MAKE) brew-upgrade

upgrade: brew-upgrade
brew-upgrade:
	${HOME}/.homebrew/bin/brew update --force
	${HOME}/.homebrew/bin/brew bundle --verbose --file global/Brewfile
	-${HOME}/.homebrew/bin/brew bundle --verbose --file local/Brewfile

clean: brew-clean
brew-clean:
	rm -rf ${HOME}/.homebrew
