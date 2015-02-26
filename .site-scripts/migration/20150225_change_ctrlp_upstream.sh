#!/bin/bash

set -e

ORIG=$PWD

cd $HOME

rm -rf .vim/bundle/vim-ctrlp
git submodule deinit .vim/bundle/vim-ctrlp
git submodule update --init
