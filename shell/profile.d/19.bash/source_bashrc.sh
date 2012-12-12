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

if [ -n "$BASH" ]; then
	export XP_SHELL="$BASH"
elif [ -n "$SHELL" ]; then
	export XP_SHELL="$SHELL"
else
	export XP_SHELL='unspecified'
fi

echo "`printf "\033[32mYour shell is: ${XP_SHELL}\033[0m"`"

if [ -z "$BASH" ]; then
	if [ -z "$SHELL" ]; then
		echo "`printf "\033[31mWarning: You are using an unspecified shell.\033[0m"`"
	else
		case "$SHELL" in
			*/bash)
				echo "`printf "\033[31mWarning: You are using an abnormal version of bash.  Things may not work properly.\033[0m"`"
				[ -x "$XP_SHELL_FOLDER/bash_profile.sh" ] && source "$XP_SHELL_FOLDER/bash_profile.sh"
				;;

			*/sh)
				echo "`printf "\033[31mWarning: You are using sh, not bash.  A lot of features are disabled.\033[0m"`"
				;;

			*)
				echo "`printf "\033[31mWarning: You are using an unrecognized shell (\"$SHELL\").  bash-specific features have been disabled.\033[0m"`"
				;;
		esac
	fi
else
	case "$BASH" in
		*/bash)
			[ -x "$XP_SHELL_FOLDER/bash_profile.sh" ] && source "$XP_SHELL_FOLDER/bash_profile.sh" || echo 
			;;

		*/sh)
			echo "`printf "\033[31mWarning: You are using bash in sh emulation mode.  A lot of features are disabled.\033[0m"`"
			;;

		*)
			echo "`printf "\033[31mWarning: You are using an unrecognized shell (\"$SHELL\") that is pretending to be bash.  bash-specific features have been disabled.\033[0m"`"
			;;
	esac
fi

