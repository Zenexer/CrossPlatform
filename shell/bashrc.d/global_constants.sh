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
if [ -z "$XP_NO_COLOR_PS" ]; then
	export PS1='\[\e[0m\][${XP_CHROOT:+(\[\e[31m\]$XP_CHROOT )}\[\e[32m\]\u\[\e[0m\]@\[\e[32m\]\h\[\e[0m\]:\[\e[34m\]\W\[\e[0m\]]\[\e[31m\]\$\[\e[0m\] '
else
	# Use one escape code to reset formatting, even though we aren't using color.
	export PS1='\[\e[0m\][${XP_CHROOT:+($XP_CHROOT )}\u@\h:\W]\$ '
fi

# Command History {{{1
HISTSIZE=1024
HISTFILESIZE=4096

# Don't put lines starting with space or duplicates in history.
HISTCONTROL=ignoreboth

# Temporary Directory {{{1
if [ -z "$XP_NO_TEMP" ]; then
	if [ -z "$XP_TEMP" ]; then
		auto_temp=yes
	elif [ -e "$XP_TEMP" -d "$XP_TEMP" -w "$XP_TEMP" ]; then
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
		elif [ ! -e "$HOME/tmp" -a -d "$HOME" -w "$HOME" ]; then
			XP_TEMP="$HOME/tmp"
			mkdir "$XP_TEMP" && set_temp=yes || set_temp=no
		elif [ ! -e "$HOME/.tmp" -a -d "$HOME" -w "$HOME" ]; then
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

# Terminal Colors {{{1
[ -z "$XP_COLORS" ] && export XP_COLORS='256color'
if [ -z "$XP_NO_COLOR" ]; then
	case "$TERM" in
		*-color)
			export TERM="${TERM%-color}-${XP_COLOR}"
			;;

		*-8color | *-16color | *-256color)
			[ -n "$XP_FORCE_COLOR" ] && export TERM="${TERM%-*color}-${XP_COLOR}"
			;;

		*)
			export TERM="${TERM}-${XP_COLOR}"
			;;
	esac
fi

