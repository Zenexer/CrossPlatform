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
#
#

if whoami &> /dev/null; then
	user='\u'
elif [ -n "$UID" ]; then
	user="$UID"
else
	user='unknown'
fi

export PROMPT_COMMAND='prompt_status="$? "; if [[ $prompt_status == "0 " ]]; then prompt_status=; fi' # Byobu
if [ -z "$XP_NO_COLOR_PS" ]; then
	# Based on Byobu
	export PS1='${debian_chroot:+($debian_chroot)}\[\e[38;5;202m\]$prompt_status\[\e[38;5;245m\]\u\[\e[00m\]@\[\e[38;5;5m\]\h\[\e[00m\]:\[\e[38;5;172m\]\w\[\e[00m\]\$ '
else
	# Use one escape code to reset formatting, even though we aren't using color.
	export PS1='\[\e[0m\]${prompt_status}${debian_chroot:+($debian_chroot)}\u@\h \w\$ '
fi

unset user

