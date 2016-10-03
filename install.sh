#!/usr/bin/env bash
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

	if [ -h "$TARGET" ]; then
		if ! rm -f "$TARGET"; then
			echo $'\e[31m'"Could not install '$INSTALL' to '$TARGET': unable to remove old symbolic link."$'\e[m'
			return 1
		fi
	elif [[ -e "$TARGET" && ! -e "$BACKUP" ]]; then
		mv "$TARGET" "$BACKUP" || EXIT_CODE=$?
		if (( $EXIT_CODE )); then
			echo $'\e[31m'"Could not install '$INSTALL' to '$TARGET': unable to back up existing file."$'\e[m'
			return $EXIT_CODE
		else
			echo $'\e[0m'"Moved original '$TARGET' to '$BACKUP'."
		fi
	fi

	ln -s "$INSTALL" "$TARGET" || EXIT_CODE=$?
	if ! (( $EXIT_CODE )); then
		echo $'\e[32m'"Linked '$TARGET' to '$INSTALL'."$'\e[m'
		return 0
	fi

	echo $'\e[31m'"Could not install '$INSTALL' to '$TARGET': unable to make symbolic link."$'\e[m'
	return $EXIT_CODE
}

# install_script {{{2
install_script()
{
	ext="$1"
	INSTALL="$2"
	TARGET="$3"

	if [ -z "$4" ]; then
		FOLDER="$TARGET.d"
	else
		FOLDER="$4"
	fi

	if [ -z "$5" ]; then
		BACKUP="$FOLDER/10-default.$ext"
	else
		BACKUP="$FOLDER/$5"
	fi

	if [ ! -d "$FOLDER" ]; then
		mkdir "$FOLDER" || EXIT_CODE=$?
		if ! (( $EXIT_CODE )); then
			echo $'\e[0m'"Created '$FOLDER' to hold any pre-existing scripts."
		else
			echo $'\e[31m'"Could not install '$INSTALL' to '$TARGET': unable to create folder '$FOLDER'."$'\e[0m'
			return $EXIT_CODE
		fi
	fi

	install_file "$INSTALL" "$TARGET" "$BACKUP" || EXIT_CODE=$?
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
	pushd "$XP_FOLDER" > /dev/null || exit $?
	git submodule init
	git submodule update
	popd > /dev/null
fi

make_folder ~/tmp
make_folder ~/.swp
make_folder ~/.backup
make_folder ~/.undo
make_folder ~/.config/nvim
make_folder ~/.zsh/cache
make_folder ~/.zsh/init
make_folder ~/.local/share/nvim/backup
make_folder ~/.local/share/nvim/swap
make_folder ~/.local/share/nvim/undo

install_script  sh   shell/bashrc.sh    ~/.bashrc       ~/.bashrc.d
install_script  zsh  zsh/zshrc.zsh      ~/.zshrc.local  ~/.zsh/init
install_file    vim/vimrc.vim           ~/.vimrc
install_file    config/screen.screenrc  ~/.screenrc
install_file    config/tmux.conf        ~/.tmux.conf
install_file    nvim/config/init.vim    ~/.config/nvim/init.vim

"$XP_FOLDER/grml.sh"
"$XP_FOLDER/git.sh" && true

case "$OSTYPE" in
	darwin*)
		if ! grep -qF '/.bashrc' /etc/bashrc; then
			if ! grep -qF -e '~/.bashrc' -e '$HOME/.bashrc' /etc/bashrc; then
				local yn=
				echo -n $'\e[31mPatch /etc/bashrc? [y/n]:\e[m ' >&2
				read -srn1 yn || true
				echo
				if [[ "$yn" = 'y' || "$yn" = 'Y' ]]; then
					echo "Patching..." >&2
					sudo tee -a /etc/bashrc <<< $'\n\n[ -e ~/.bashrc ] && . ~/.bashrc'
				else
					echo "Skipping patch" >&2
				fi
			fi
		fi
		;;
esac

case "$(basename "$SHELL")" in
	zsh|bash)
		echo $'\e[31mLog in again or run: \e[m. ~/.'"$(basename "$SHELL")"'rc'
		;;

	*)
		echo $'\e[31mLog in again with bash or zsh.\e[m'
		;;
esac

