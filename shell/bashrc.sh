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

# -f flag for readlink is a GNU thing
readlinkf()
{
	readlink -f "$1" 2> /dev/null || readlink "$(cd "$(dirname "$1")" && pwd -P)/$(basename "$1")"
}

if [[ "$OSTYPE" == 'cygwin' ]] && ! type readlink > /dev/null 2>&1; then
	export PATH="/usr/local/bin:/usr/bin:$PATH"
fi
export XP_FOLDER="$(cd "$(dirname "$(readlinkf "${BASH_SOURCE[0]}")")" && cd .. && pwd)"

# Sourcing {{{1
#
#

# ~/.bashrc.d {{{2
if [ -d "$BASHRC_FOLDER" ]; then
	for f in "$BASHRC_FOLDER"/*; do
		[ -x "$f" ] && source "$f"
	done
fi
unset BASHRC_FOLDER

# $XP_FOLDER/shell/profile.sh {{{2
if [[ -x "$XP_FOLDER/shell/bash_profile.sh" ]]; then
	. "$XP_FOLDER/shell/bash_profile.sh"
fi
if [[ -e ~/.cargo/env ]]; then
	. ~/.cargo/env
fi
