#!/bin/bash
# Header Comments {{{1
#
# vim: ts=4 sw=4 sr sts=4 fdm=marker fmr={{{,}}} ff=unix fenc=utf-8
#	ts:		Actual tab character stops.
#	sw:		Indentation commands shift by this much.
#	sr:		Round existing indentation when using shift commands.
#	sts:	Virtual tab stops while using tab key.
#	fdm:	Folds are manually defined in file syntax.
#	fmr:	Folds are denoted by {{{ and }}}.
#	ff:		Line endings should always be <NL> (line feed #09).
#	fenc:	Should always be UTF-8; #! must be first bytes, so no BOM.
#


# Prompts {{{1
#
#

if whoami &> /dev/null; then
	user='\u'
elif [ -n "$UID" ]; then
	user="$UID"
else
	user='unknown'
fi

if [ -z "$XP_NO_COLOR_PS" ]; then
	export PS1='\[\e[33m\][${XP_CHROOT:+(\[\e[31m\]$XP_CHROOT )}\[\e[32m\]'$user'\[\e[33m\]@\[\e[35m\]\h \[\e[36m\]\W\[\e[33m\]]\[\e[31m\]\$\[\e[0m\] '
else
	# Use one escape code to reset formatting, even though we aren't using color.
	export PS1='\[\e[0m\][${XP_CHROOT:+($XP_CHROOT )}'$user'@\h \W]\$ '
fi

unset user

