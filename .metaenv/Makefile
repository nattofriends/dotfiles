SHELL := /bin/bash
MAKEFLAGS += --jobs=4

help:
	@echo "install to reinstall packages"
	@echo "upgrade to upgrade packages"
	@echo "metapath to create symlinks"

install:

update: upgrade
upgrade:

clean:
	rm -rf bin

.PHONY: metapath
metapath:
	mkdir -p bin
	./metapath.py bin

include make/cargo.mk
include make/go.mk
include make/homebrew.mk
include make/npm.mk
include make/python.mk

-include Makefile.local
