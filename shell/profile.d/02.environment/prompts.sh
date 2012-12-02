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

if [ -z "$XP_NO_COLOR_PS" ]; then
	export PS1='\[\e[0m\][${XP_CHROOT:+(\[\e[31m\]$XP_CHROOT )}\[\e[32m\]\u\[\e[0m\]@\[\e[32m\]\h\[\e[0m\]:\[\e[34m\]\W\[\e[0m\]]\[\e[31m\]\$\[\e[0m\] '
else
	# Use one escape code to reset formatting, even though we aren't using color.
	export PS1='\[\e[0m\][${XP_CHROOT:+($XP_CHROOT )}\u@\h:\W]\$ '
fi

