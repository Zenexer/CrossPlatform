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


# Locale {{{1
#
#

[ -z "$XP_LOCALE_PRIMARY" ] && export XP_LOCALE_PRIMARY='en'
[ -z "$XP_LOCALE_SECONDARY" ] && export XP_LOCALE_SECONDARY='US'
[ -z "$XP_LOCALE" ] && export XP_LOCALE="${XP_LOCALE_PRIMARY}.${XP_LOCALE_SECONDARY}"
[ -z "$XP_LOCALE_ENCODING" ] && export XP_LOCALE_ENCODING='UTF-8'

[ -z "$XP_LANG" ] && export XP_LANG="${XP_LOCALE}.${XP_LOCALE_ENCODING}"
[ -z "$XP_NO_LANG" -a -z "$LANG" ] && export LANG="$XP_LANG"

[ -z "$XP_SUPPORTED" ] && export XP_SUPPORTED=":${XP_LOCALE_PRIMARY}.${XP_LOCALE_SECONDARY}.${XP_LOCALE_ENCODING}:${XP_LOCALE_PRIMARY}"
[ -z "$XP_NO_SUPPORTED" -a -z "$SUPPORTED" ] && export SUPPORTED="$XP_SUPPORTED"

