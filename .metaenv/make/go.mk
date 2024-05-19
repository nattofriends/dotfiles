install: go
go: GOPATH=${HOME}/.go
go:
	command -v go && set -x && while read i; do \
		go get -v $$i && sh -xc "go install -v $$i@latest"; \
		done < <(cat $@.txt $@-local.txt) || echo "prerequisite not installed, skipping"

clean: go-clean
go-clean:
	rm -rf ${HOME}/.go
