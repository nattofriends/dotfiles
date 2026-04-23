install: npm
npm:
	command -v npm && set -x && while read i; do \
		[[ "$$i" != \#* ]] && sh -xc "npm install -g $$i"; \
		done < <(cat global/$@.txt local/$@.txt) || echo "npm not installed, skipping"

upgrade: npm-upgrade
npm-upgrade:
	command -v npm && npm upgrade -g || echo "npm not installed, skipping"

clean: npm-clean
npm-clean:
	rm -rf ${HOME}/.npm-prefix

# Optional
nvm-bootstrap:
	git clone https://github.com/nvm-sh/nvm ${HOME}/.nvm

upgrade: nvm-upgrade
nvm-upgrade:
	[ -d ${HOME}/.nvm ] || (echo "prerequisite not installed, skipping $@" && false)
	cd ${HOME}/.nvm && git pull

clean: nvm-clean
nvm-clean:
	rm -rf ${HOME}/.nvm
