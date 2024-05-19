install: cargo
# https://nickgerace.dev/post/how-to-manage-rust-tools-and-applications/
cargo:
	command -v cargo && set -x && while read i; do \
		[[ "$$i" != \#* ]] && sh -xc "cargo install $$i; \
		done < <(cat cargo{,-local}.txt) || echo "prerequisite not installed, skipping"

.PHONY: cargo-bootstrap
cargo-bootstrap:
	curl https://sh.rustup.rs -sSf | sh -s -- --no-modify-path -y

upgrade: cargo-upgrade
cargo-upgrade:
	command -v rustup && rustup update || echo "rustup not installed, skipping"
	command -v cargo && cargo install-update --all || echo "cargo not installed, skipping"

clean: cargo-clean
cargo-clean:
	rm -rf ${HOME}/.cargo
