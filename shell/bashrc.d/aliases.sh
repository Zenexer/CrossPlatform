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

# egrep and fgrep are deprecated; might as well add rgrep, too.
alias egrep='grep -E'
alias fgrep='grep -F'
alias rgrep='grep -r'

# Useful permutations of ls.
alias ll='ls -alF'
alias la='ls -AF'
alias l='ls -CF'

