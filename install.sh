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


# install_file {{{2
install_file()
{
	TARGET="$2"
	INSTALL="$XP_FOLDER/$1"

	if [ -z "$3" ]; then
		BACKUP="$TARGET.bak"
	else
		BACKUP="$3"
	fi

	if [ -e "$TARGET" ]; then
		mv "$TARGET" "$BACKUP"
		EXIT_CODE=$?
		if [ $EXIT_CODE ]; then
			echo $'\e[0m'"Moved original '$TARGET' to '$BACKUP'."
		else
			echo $'\e[31m'"Could not install '$INSTALL' to '$TARGET': unable to back up existing file."$'\e[0m'
			return $EXIT_CODE
		fi
	fi

	ln -s "$INSTALL" "$TARGET"
	EXIT_CODE=$?
	if ! (( $EXIT_CODE )); then
		echo $'\e[32m'"Linked '$TARGET' to '$INSTALL'."$'\e[0m'
		return 0
	fi

	echo $'\e[31m'"Could not install '$INSTALL' to '$TARGET': unable to make symbolic link."$'\e[0m'
	return $EXIT_CODE
}

# install_script {{{2
install_script()
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
		echo $'\e[0m'"Created '$FOLDER' to hold any pre-existing scripts."
	else
		echo $'\e[31m'"Could not install '$INSTALL' to '$TARGET': unable to create folder '$FOLDER'."$'\e[0m'
		return $EXIT_CODE
	fi

	install_file "$INSTALL" "$TARGET" "$BACKUP"
	EXIT_CODE=$?
	[ -e "$BACKUP" ] && chmod +x "$BACKUP"
	return $EXIT_CODE
}

# make_folder {{{2
make_folder()
{
	[ ! -e "$1" ] && mkdir -p "$1"
}


# Installation Manifest {{{1
#
#

if [ $# -lt 1 ]; then
	pushd "$XP_FOLDER" || exit $?
	git submodule init
	git submodule update
	popd
fi

make_folder ~/tmp
make_folder ~/.swp
make_folder ~/.backup
make_folder ~/.undo

install_script 'shell/bashrc.sh' ~/.bashrc ~/.bashrc.d
install_file 'vim/vimrc.vim' ~/.vimrc
install_file 'config/screenrc.screen' ~/.screenrc

echo $'\e[31mLog in again or run: \e[msource ~/.bashrc'

