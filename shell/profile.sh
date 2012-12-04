#!/bin/sh
# THIS SHOULD BE /bin/bash so that the script runs under bash when being invoked directly.
# Header Comments {{{1
# vim: ts=4 sw=4 sr sts=4 fdm=marker fmr={{{,}}} ff=unix fenc=utf-8 tw=130
#	ts:		Actual tab character stops.
#	sw:		Indentation commands shift by this much.
#	sr:		Round existing indentation when using shift commands.
#	sts:	Virtual tab stops while using tab key.
#	fdm:	Folds are manually defined in file syntax.
#	fmr:	Folds are denoted by {{{ and }}}.
#	ff:		Line endings should always be <NL> (line feed #09).
#	fenc:	Should always be UTF-8; #! must be first bytes, so no BOM.
#	tw:		Maximum width of a line before it auto-wraps.
#
# All CrossPlatform constants begin with "XP_".
#	Out/In:
#		XP_FOLDER			The name of the CrossPlatform root folder.
#		XP_SHELL_FOLDER		The name of the CrossPlatform shell folder.
#		XP_CHROOT			The determined chroot directory.
#		
#	In:
#		XP_COLOR			The number of colors to use for the terminal.  Defaults to 256color.  Customarily valid options are
#							8color, 16color,
#							and 256color.  Most modern xterm-compatible terminals support 256 colors.
#		XP_NO_COLOR			If set, prevents a color prefix from being appended to $TERM.
#		XP_FORCE_COLOR		If set, force setting of terminal colors, even if the number of colors is already specified.
#		XP_NO_TEMP			If set, don't change $TEMP et al.
#		XP_TEMP				If set, uses the given temporary directory.
#		XP_NO_COLOR_PS		If set, the PS# variables won't be set with color codes.
#		XP_NO_DIRCOLORS		Don't use dircolors.
#


# Initialization {{{1
#
#

# XP_FOLDER
[ -z "$XP_FOLDER" ] && export XP_FOLDER="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd ..  && pwd)"

# XP_SCRIPT_FOLDER
[ -z "$XP_SHELL_FOLDER" ] && export XP_SHELL_FOLDER="$XP_FOLDER/shell"

# XP_CHROOT
if [ -z "$XP_CHROOT" ]; then
	if [ ! -z "$debian_chroot" ]; then
		XP_CHROOT="$debian_chroot"
	elif [ ! -z "$CHROOT" ]; then
		XP_CHROOT="$CHROOT"
	fi
fi


# Functions {{{1
#
#

function append_path # {{{2
{
	if ! eval test -z "\"\${$1##*:$2:*}\"" -o -z "\"\${$1%%*:$2}\"" -o -z "\"\${$1##$2:*}\"" -o -z "\"\${$1##$2}\""; then
		eval "export $1=\$$1:$2"
	fi
}

function prepend_path # {{{2
{
	if ! eval test -z "\"\${$1##*:$2:*}\"" -o -z "\"\${$1%%*:$2}\"" -o -z "\"\${$1##$2:*}\"" -o -z "\"\${$1##$2}\""; then
		eval "export $1=$2:\$$1"
	fi
}

function source_folder # {{{2
{
	[ ! -d "$1" ] && return
	
	if [ -n "$IFS" ]; then
		OLDIFS="$IFS"
		IFS=''
	fi

	for level in $1/0{0..9}.*; do
		[ ! -d "$level" ] && continue;

		for file in $level/*.sh; do
			[ -x "$file" ] && . "$file"
		done
	done

	for level in $1/{10..19}.*; do
		[ ! -d "$level" ] && continue;

		for file in $level/*.sh; do
			[ -x "$file" ] && . "$file"
		done
	done

	for file in $1/*.sh; do
		[ -x "$file" ] && . "$file"
	done

	if [ -n "$OLDIFS" ]; then
		IFS="$OLDIFS"
		unset OLDIFS
	fi
}


# profile.d Scripts {{{1
#
#

source_folder "$XP_SHELL_FOLDER/profile.d"

