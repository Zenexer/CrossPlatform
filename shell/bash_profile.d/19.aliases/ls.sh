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


# ls {{{1
#
#

if ls --color=auto -F > /dev/null 2>&1; then
	alias ls='ls --color=auto -F'  # Linux
elif ls -GF > /dev/null 2>&1; then
	alias ls='ls -GF'  # Mac
elif ls -F > /dev/null 2>&1; then
	alias ls='ls -F'
fi

alias ll='ls -alh'
alias la='ls -A'
alias l='ls -C'

