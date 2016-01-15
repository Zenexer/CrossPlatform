#!/bin/sh

if type wget; then
	wget -O ~/.zshrc http://git.grml.org/f/grml-etc-core/etc/zsh/zshrc || exit $?
	if [ ! -e ~/.zshrc.local ]; then
		wget -O ~/.zshrc.local http://git.grml.org/f/grml-etc-core/etc/skel/.zshrc || exit $?
	fi
elif type curl; then
	curl -o ~/.zshrc http://git.grml.org/f/grml-etc-core/etc/zsh/zshrc || exit $?
	if [ ! -e ~/.zshrc.local ]; then
		curl -o ~/.zshrc.local http://git.grml.org/f/grml-etc-core/etc/skel/.zshrc || exit $?
	fi
else
	echo "Couldn't find wget or curl" >&2
	exit 1
fi

true
