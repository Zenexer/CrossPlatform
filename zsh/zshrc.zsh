#!/usr/bin/env zsh
# vim: ts=4 sw=4 sts=4 sr sts=4 noet ff=unix fenc=utf-8

__hasterm_method=

hasterm()
{
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

chooseterm()
{
	local i=
	for i in "$@"; do
		if hasterm "$i"; then
			echo "$i"
			return 0
		fi
	done
	false
}

fixterm()
{
	local term=

	case "$TERM" in
		screen|screen-256color)
			if (( $+TMUX )); then
				chooseterm tmux-256color screen-256color xterm-256color && return 0 || return 1
			else
				chooseterm screen-256color xterm-256color && return 0 || return 1
			fi
			;;

		*-256color)
			chooseterm "$TERM" xterm-256color && return 0 || return 1
			;;

		xterm)
			echo "Warning: Ambiguous terminal: $TERM" >&2
			chooseterm "$TERM-256color" linux-256color && return 0 || return 1
			;;

		linux|putty)
			chooseterm "$TERM-256color" xterm-256color && return 0 || return 1
			;;

		cygwin)
			chooseterm "$TERM-256color" putty-256color && return 0 || return 1
			;;

		freebsd|netbsd)
			chooseterm "$TERM-256color" xterm-256color && return 0 || return 1
			;;

		gnome|xfce)
			chooseterm "$TERM-256color" linux-256color xterm-256color && return 0 || return 1
			;;

		*-*|*.*|*+*)
			chooseterm "$TERM" "$TERM-256color" && return 0 || return 1
			;;

		*)
			chooseterm "$TERM-256color" xterm-256color && return 0 || return 1
			;;

	esac
}

export TERM="$(fixterm)"
echo "TERM=$TERM" >&2

if [[ -d ~/.zsh/init ]]; then
	for f in ~/.zsh/init/*; do
		. "$f"
	done
	unset f
fi
