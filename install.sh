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

XP_FOLDER="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


# Functions {{{1
#
#

function install_file # {{{2
{
	TARGET="$2"
	INSTALL="$XP_FOLDER/install/$1"

	if [ -z "$3" ]; then
		BACKUP="$TARGET.bak"
	else
		BACKUP="$3"
	fi

	if [ -e "$TARGET" ]; then
		mv "$TARGET" "$BACKUP"
		EXIT_CODE=$?
		if [ ! $EXIT_CODE ]; then
			echo $"\033[31mCould not install '$INSTALL' to '$TARGET': unable to back up existing file.\033[0m"
			return $EXIT_CODE
		fi
	fi

	ln -s "$INSTALL" "$TARGET"
	EXIT_CODE=$?
	if [ $EXIT_CODE ]; then
		echo $"\033[32mInstalled '$INSTALL' to '$TARGET'.\033[0m"
		return 0
	fi

	echo $"\033[31mCould not install '$INSTALL' to '$TARGET': unable to make symbolic link.\033[0m"
	return $EXIT_CODE
}

function install_script # {{{2
{
	INSTALL="$1"
	TARGET="$2"

	if [ -z "$3" ]; then
		FOLDER="$TARGET.d"
	else
		FOLDER="$3"
	fi

	if [ -z "$4" ]; then
		BACKUP="$FOLDER/default.sh"
	else
		BACKUP="$FOLDER/$4"
	fi

	mkdir "$FOLDER"
	EXIT_CODE=$?
	if [ $EXIT_CODE ]; then
		echo $"\033[31mCould not install '$INSTALL' to '$TARGET': unable to create folder '$FOLDER'.\033[0m"
	fi

	install_file "$INSTALL" "$TARGET" "$BACKUP"
}


# Installation Manifest {{{1
#
#

install_script 'bashrc.sh' ~/.bashrc ~/bashrc.d
install_file 'vimrc.vim' ~/.vimrc

