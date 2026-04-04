#!/bin/bash

git submodule foreach 'git checkout $(git config --file=$toplevel/.gitmodules --get submodule.$name.branch)'

git submodule foreach git pull
