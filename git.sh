#!/bin/bash

type git || exit $?

git config --global alias.lol 'log --graph --decorate --pretty=oneline --abbrev-commit'
git config --global alias.lola 'log --graph --decorate --pretty=oneline --abbrev-commit --all'
