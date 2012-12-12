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


# Terminal Colors {{{1
#
#

function make_color_alias
{
	if [ -z "$1" ]; then
		echo $'\033[31mWarning: make_color_alias requires at least one argument.'
		return
	fi

	for i in $@; do
		alias $i="$i --color=auto"
	done
}

if [ -z "$XP_NO_COLOR" ] && which 'dircolors' &> /dev/null; then
	if [ -r ~/.dircolors ]; then
		eval "`dircolors -b ~/.dircolors`"
	elif [ -r "$XP_SHELL_FOLDER/dircolors" ]; then
		eval "` dircolors -b "$XP_SHELL_FOLDER/dircolors"`"
	else
		eval "`dircolors -b`"
	fi

	make_color_alias ls
	make_color_alias dir vdir
	make_color_alias grep fgrep egrep
fi

