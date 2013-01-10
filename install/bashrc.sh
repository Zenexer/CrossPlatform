#!/bin/bash
# vim: ts=4 sw=4 sr sts=4 fdm=marker fmr={{{,}}} ff=unix fenc=utf-8 tw=130
# 	ts:	Actual tab character stops.
# 	sw:	Indentation commands shift by this much.
# 	sr:	Round existing indentation when using shift commands.
# 	sts:	Virtual tab stops while using tab key.
# 	fdm:	Folds are manually defined in file syntax.
# 	fmr:	Folds are denoted by {{{ and }}}.
# 	ff:	Line endings should always be <NL> (line feed #09).
# 	fenc:	Should always be UTF-8; #! must be first bytes, so no BOM.
# 	tw:	Maximum width of a line before it auto-wraps.

# Environment {{{1
#
#

XP_FOLDER="$(cd "$(dirname "$(readlink -fn "${BASH_SOURCE[0]}")")/.." && pwd)"
BASHRC_FOLDER="$(cd "$(dirname "${BASH_SOURCE[0]}")/.bashrc.d" && pwd)"


# Sourcing {{{1
#
#

# $XP_FOLDER/shell/profile.sh {{{2
[ -x "$XP_FOLDER/shell/profile.sh" ] && "$XP_FOLDER/shell/profile.sh"

# ~/.bashrc.d {{{2
for f in "$BASHRC_FOLDER"/*; do
	if [ -x "$f" ]; then
		source "$f" || echo $'\033[31m'"bashrc script '$f' encountered an error. (Error code: $?)"$'\033[0m'
	fi
done

