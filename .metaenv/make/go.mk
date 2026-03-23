install: go
go: export GOPATH=${HOME}/.go
go:
	command -v go && set -x && while read i; do \
		sh -c "go install -v $$i@latest"; \
		done < <(cat global/$@.txt local/$@.txt) || echo "prerequisite not installed, skipping"

clean: go-clean
go-clean:
	rm -rf ${HOME}/.go
