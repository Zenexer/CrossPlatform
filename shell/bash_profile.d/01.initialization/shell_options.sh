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


# Shell Options {{{1
#
#

setopt()
{
	shopt -s "$1" > /dev/null 2>&1
}

# Update window size after each command.
setopt checkwinsize

# Append to history file; don't overwrite it.
setopt histappend

# Allow globstar (**).
setopt globstar

# Store multi-line commands in single history entries.
setopt cmdhist

# Allow pattern lists in pathname expansion, such as ?(...|...)
setopt extglob
