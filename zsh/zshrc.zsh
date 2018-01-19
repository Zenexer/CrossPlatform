#!/usr/bin/env zsh
# vim: ts=4 sw=4 sts=4 sr sts=4 noet ff=unix fenc=utf-8

REPORTTIME=2
VIM_OPTIONS=( -p )
NVIM_OPTIONS=$VIM_OPTIONS

case "$COLORTERM" in
	yes|truecolor|24bit)
		export COLORTERM=truecolor
		TMUX_OPTIONS=( )
		;;

	*)
		TMUX_OPTIONS=( -2 )
		;;
esac

function hasterm() {
	emulate -L zsh

	if (( ! $+__hasterm_method )); then
		typeset -g __hasterm_method
	fi

	if [[ -z "$__hasterm_Method" ]]; then
		if tput colors &> /dev/null; then
			__hasterm_method=tput
		elif infocmp &> /dev/null; then
			__hasterm_method=infocmp
		elif toe -a | grep "^${TERM}\$" &> /dev/null; then
			__hasterm_method=toe
		else
			__hasterm_method=none
			echo "Warning: Can't check TERM validity" >&2
		fi
	fi

	case "$__hasterm_method" in
		tput)
			(( $(tput -T"$1" colors 2> /dev/null || echo -2) >= 256 )) && return 0 || return 1
			;;

		infocmp)
			infocmp "$1" &> /dev/null && return 0 || return 1
			;;

		toe)
			toe -a | grep "^${1}\$" &> /dev/null && return 0 || return 1
			;;

		none)
			return 0
			;;

		*)
			echo "Error: Unrecognized __hasterm_method: $__hasterm_method" >&2
			;;
	esac
}

function chooseterm() {
	emulate -L zsh

	local i=
	for i in "$@"; do
		if hasterm "$i"; then
			echo "$i"
			return 0
		fi
	done
	false
}

function fixterm() {
	emulate -L zsh

	case "$TERM" in
		screen|screen-256color)
			if (( $+TMUX )); then
				chooseterm tmux-256color screen-256color linux xterm-256color && return 0 || return 1
			else
				chooseterm screen-256color linux xterm-256color && return 0 || return 1
			fi
			;;

		linux|xterm-256color)
			echo "$TERM"
			return 0
			;;

		*-256color)
			chooseterm "$TERM" xterm-256color && return 0 || return 1
			;;

		xterm)
			echo "Warning: Ambiguous terminal: $TERM" >&2
			chooseterm "$TERM-256color" linux && return 0 || return 1
			;;

		putty)
			chooseterm linux xterm-256color && return 0 || return 1
			;;

		cygwin)
			chooseterm "$TERM-256color" putty-256color && return 0 || return 1
			;;

		freebsd|netbsd)
			chooseterm "$TERM-256color" xterm-256color && return 0 || return 1
			;;

		gnome|xfce)
			chooseterm "$TERM-256color" linux xterm-256color && return 0 || return 1
			;;

		*-*|*.*|*+*)
			chooseterm "$TERM" "$TERM-256color" && return 0 || return 1
			;;

		*)
			chooseterm "$TERM-256color" "$TERM" xterm-256color && return 0 || return 1
			;;

	esac
}

function echoco() {
	echoti setaf "$1"
	echo "${@:2}"
	echoti sgr0
}

function debug() {
	echoco 8 - "$*"
}


export ORIG_TERM="$TERM"
export TERM="$(fixterm)"
debug "Terminal: $ORIG_TERM -> $TERM" >&2

if check_com -c nvim; then
	export EDITOR=nvim
fi

nvim() {
	VIM_PLEASE_SET_TITLE=yes command nvim $NVIM_OPTIONS "$@"
}

tmux() {
	command tmux $TMUX_OPTIONS "$@"
}

if [[ -d ~/.zsh/init ]]; then
	for f in ~/.zsh/init/*(N-.Y1); do
		. "$f"
	done
	unset f
fi

