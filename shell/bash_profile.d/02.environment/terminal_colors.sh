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

[ -z "$XP_COLOR" ] && export XP_COLOR='256color'

if [ -z "$XP_NO_COLOR" ]; then
	case "$TERM" in
		*-color)
			export TERM="${TERM%-color}-${XP_COLOR}"
			;;

		*-8color | *-16color)
			[ -z "$XP_NO_FORCE_COLOR" ] && export TERM="${TERM%-*color}-${XP_COLOR}"
			;;

		xterm)
			export TERM="xterm-$XP_COLOR"
			;;

		*)
			;;
	esac
fi

