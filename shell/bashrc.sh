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
#		XP_CHROOT		The determined chroot directory.
#		
#	In:
#		XP_COLOR		The number of colors to use for the terminal.  Defaults to 256color.  Customarily valid options are 8color, 16color,
#						and 256color.  Most modern xterm-compatible terminals support 256 colors.
#		XP_NO_COLOR			If set, prevents a color prefix from being appended to $TERM.
#		XP_FORCE_COLOR		If set, force setting of terminal colors, even if the number of colors is already specified.
#		XP_NO_TEMP			If set, don't change $TEMP et al.
#		XP_TEMP				If set, uses the given temporary directory.
#		XP_NO_COLOR_PS		If set, the PS# variables won't be set with color codes.
#		XP_NO_DIRCOLORS		Don't use dircolors.
#

# Only run on interactive shells.
[ -z "$PS1" ] && return

# XP_FOLDER
[ -z "$XP_FOLDER" ] && export XP_FOLDER="$(cd "$(dirname "${BASH_PATH[0]}")" && pwd)"

# XP_CHROOT
if [ -z "$XP_CHROOT" ]; then
	if [ ! -z "$debian_chroot" ]; then
		XP_CHROOT="$debian_chroot"
	elif [ ! -z "$CHROOT" ]; then
		XP_CHROOT="$CHROOT"
	fi
fi

for i in $XP_FOLDER/bashrc.d/*.sh; do
	[ -x "$i" ] && . "$i"
done

