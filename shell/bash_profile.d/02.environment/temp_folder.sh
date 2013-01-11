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


# Temporary Folder {{{1
#
#

if [ -z "$XP_NO_TEMP" ]; then
	if [ -z "$XP_TEMP" ]; then
		auto_temp=yes
	elif [ -e "$XP_TEMP" -a -d "$XP_TEMP" -a -w "$XP_TEMP" ]; then
		auto_temp=no
	elif [ -e "$XP_TEMP" ]; then
		auto_temp=yes
	else
		mkdir "$XP_TEMP" && auto_temp=no || auto_tmp=yes
	fi

	if [ "$auto_temp" = yes ]; then
		if [ -d "$HOME/tmp" -a -w "$HOME/tmp" ]; then
			XP_TEMP="$HOME/tmp"
			set_temp=yes
		elif [ -d "$HOME/.tmp" -a -w "$HOME/.tmp" ]; then
			XP_TEMP="$HOME/.tmp"
			set_temp=yes
		elif [ ! -e "$HOME/tmp" -a -d "$HOME" -a -w "$HOME" ]; then
			XP_TEMP="$HOME/tmp"
			mkdir "$XP_TEMP" && set_temp=yes || set_temp=no
		elif [ ! -e "$HOME/.tmp" -a -d "$HOME" -a -w "$HOME" ]; then
			XP_TEMP="$HOME/.tmp"
			mkdir "$XP_TEMP" && set_temp=yes || set_temp=no
		elif [ -d '/tmp' -a -w '/tmp' ]; then
			XP_TEMP='/tmp'
			set_temp=yes
		else
			set_temp=no
		fi
	else
		set_temp=yes
	fi

	if [ "$set_temp" = yes ]; then
		export TEMP="$XP_TEMP"
		export TMPDIR="$TEMP"
	elif [ -z "$TEMP" -a -n "$TMPDIR" ]; then
		export TEMP="$TMPDIR"
	elif [ -a "$TMPDIR" -a -n "$TEMP" ]; then
		export TMPDIR="$TEMP"
	fi

	unset auto_temp set_temp
fi

