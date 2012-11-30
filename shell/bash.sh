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
# All CrossPlatform constants begin with "XP_".
#	Bidirectional:
#		XP_FOLDER		The name of the CrossPlatform shell script directory.
#		
#	In:
#		XP_COLOR		The number of colors to use for the terminal.  Defaults to 256color.  Customarily valid options are 8color, 16color,
#						and 256color.  Most modern xterm-compatible terminals support 256 colors.
#		XP_NO_COLOR		If set, prevents a color prefix from being appended to $TERM.
#		XP_FORCE_COLOR	If set, force setting of terminal colors, even if the number of colors is already specified.
#		XP_NO_TEMP		If set, don't change $TEMP et al.
#		XP_TEMP			If set, uses the given temporary directory.
#


# Initialize CrossPlatform Constants {{{1

[ -z "$XP_FOLDER" ] && export XP_FOLDER="$(cd "$(dirname "${BASH_PATH[0]}")" && pwd)"


# Initialize Global Constants {{{1

if [ -z "$XP_NO_TEMP" ]; then
	if [ -z "$XP_TEMP" ]; then
		auto_temp=yes
	elif [ -e "$XP_TEMP" -d "$XP_TEMP" -w "$XP_TEMP" ]; then
		auto_temp=no
	elif [ -e "$XP_TEMP" ]; then
		auto_temp=yes
	else
		mkdir "$XP_TEMP" && auto_temp=0 || auto_tmp=1
	fi

	if [ "$auto_temp" = yes ]; then
		if [ -d "$HOME/tmp" -w "$HOME/tmp" ]; then
			XP_TEMP="$HOME/tmp"
		elif [ -d "$HOME/.tmp" -w "$HOME/.tmp" ]; then
			XP_TEMP="$HOME/.tmp"
		else
			set_temp=yes
		fi
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
			[ ! -z "$XP_FORCE_COLOR" ] && export TERM="${TERM%-*color}-${XP_COLOR}"
			;;

		*)
			export TERM="${TERM}-${XP_COLOR}"
			;;
	esac
fi

