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


# Require Interactive {{{1
#
#

[ -z "$PS1" ] && return


# Initialize CrossPlatform Constants {{{1
#
#

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


# Shell Options {{{1
#
#

# Update window size after each command.
shopt -s checkwinsize

# Append to history file; don't overwrite it.
shopt -s histappend

# Match recursively with **.
shopt -s globstar


# Initialize Global Constants {{{1
#
#

# Prompts {{{2
if [ -z "$XP_NO_COLOR_PS" ]
	PS1='\[\e[0m\][${XP_CHROOT:+(\[\e[31m\]$XP_CHROOT )}\[\e[32m\]\u\[\e[0m\]@\[\e[32m\]\h\[\e[0m\]:\[\e[34m\]\W\[\e[0m\]]\[\e[31m\]\$\[\e[0m\] '
else
	# Use one escape code to reset formatting, even though we aren't using color.
	PS1='\[\e[0m\][${XP_CHROOT:+($XP_CHROOT )}\u@\h:\W]\$ '
fi

# Command History {{{2
HISTSIZE=1024
HISTFILESIZE=4096

# Don't put lines starting with space or duplicates in history.
HISTCONTROL=ignoreboth

# Temporary Directory {{{2
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
		if [ -d "$HOME/tmp" -w "$HOME/tmp" ]; then
			XP_TEMP="$HOME/tmp"
			set_temp=yes
		elif [ -d "$HOME/.tmp" -w "$HOME/.tmp" ]; then
			XP_TEMP="$HOME/.tmp"
			set_temp=yes
		elif [ ! -e "$HOME/tmp" -d "$HOME" -w "$HOME" ]; then
			XP_TEMP="$HOME/tmp"
			mkdir "$XP_TEMP" && set_temp=yes || set_temp=no
		elif [ ! -e "$HOME/.tmp" -d "$HOME" -w "$HOME" ]; then
			XP_TEMP="$HOME/.tmp"
			mkdir "$XP_TEMP" && set_temp=yes || set_temp=no
		elif [ -d '/tmp' -w '/tmp' ]; then
			XP_TEMP='/tmp'
			set_temp=yes
		else
			set_temp=no
		fi
	else
		set_temp=yes
	fi

	if [ "$set_temp" = yes ]; then
		TEMP="$XP_TEMP"
		TMPDIR="$TEMP"
	elif [ -z "$TEMP" ] && [ ! -z "$TMPDIR" ]; then
		TEMP="$TMPDIR"
	elif [ -a "$TMPDIR" ] && [ ! -z "$TEMP" ]; then
		TMPDIR="$TEMP"
	fi

	unset auto_temp set_temp
fi

# Terminal Colors {{{2
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


# Directory Colors {{{1
#
#

if [ -z "$XP_NO_DIRCOLORS" -x "`which dircolors`" ]; then
	if [ -x "$HOME/dircolors" ]; then
		eval "`dircolors -b "$HOME/dircolors"`"
	elif [ -x "$XP_PATH/dircolors" ]; then
		eval "`dircolors -b "$XP_PATH/dircolors"`"
	else
		eval "`dircolors -b`"
	fi

	alias ls='ls --color=auto'
	alias dir='dir --color=auto'
	alias vdir='vdir --color=auto'
	alias grep='grep --color=auto'
fi


# Automatic Completion {{{1
#
#

if ! shopt -oq posix; then
	if [ -f "$XP_PATH/bash-completion/bash_completion.sh" ]; then
		. "$XP_PATH/bash-completion/bash_completion.sh"
	elif [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi


# General Aliases {{{1
#
#

# egrep and fgrep are deprecated; might as well add rgrep, too.
alias egrep='grep -E'
alias fgrep='grep -F'
alias rgrep='grep -r'

# Useful permutations of ls.
alias ll='ls -alF'
alias la='ls -AF'
alias l='ls -CF'

