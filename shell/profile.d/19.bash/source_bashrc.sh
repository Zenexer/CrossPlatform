#!/bin/sh
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


# Bourne-Again Shell {{{1
#
#

case "$BASH" in
	*/bash)
		[ -x "$XP_PATH/bashrc.sh" ] && . "$XP_PATH/bashrc.sh"
		;;

	*/sh)
		;;

	*)
		echo "\033[31mWarning: \$BASH has an unrecognized value of \"$BASH\".\033[0m"
		;;
esac

