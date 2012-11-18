#!vim
" Use za (not a command; the keys) in normal mode to toggle a fold.
" Use zR to expand all folds.
" META_COMMENT Modeline Definition: {{{1
	" vim: ts=4 sw=4 sr sts=4 fdm=marker fmr={{{,}}} ff=unix fenc=utf-8
	"	ts:		Actual tab character stops.
	"	sw:		Indentation commands shift by this much.
	"	sr:		Round existing indentation when using shift commands.
	"	sts:	Virtual tab stops while using tab key.
	"	fdm:	Folds are manually defined in file syntax.
	"	fmr:	Folds are denoted by {{{ and }}}.
	"	ff:		Line endings should always be <NL> (line feed #09).
	"	fenc:	Should always be UTF-8; #! must be first bytes, so no BOM.
	
" Initialization: Standardize the options and set the right encoding. {{{1
	set nocompatible				" Enable non-vi-compatible features by default.
	scriptencoding utf-8			" This script is UTF-8 from here on.


" Platform Independence: Sets the same basic defaults on all platforms. {{{1
	set encoding=utf-8				" Internal vim encoding.
	set termencoding=utf-8			" Encoding of vim output.
	set backspace=indent,eol,start	" Some implementations don't have this as the default.

	" Try to integrate with system clipboard.
	if has('unnamedplus')
		set clipboard=unnamed,unnamedplus			" Export yanked text to the X11 clipboard.
	else
		set clipboard=unnamed		" Export yanked text to the only clipboard.
	endif

	" Use .vim instead of vimfiles on Windows to make for easier transitions between systems.
	if has('win32') || has('win64')
		set runtimepath=~/.vim,$VIM/vimfiles,$VIMRUNTIME,~/.vim/after,$VIM/vimfiles/after
	endif


" Redundancy: Version control and backups. {{{1
	set directory=./.swp,~/.swp,~/tmp,/tmp,.		" Preference of swap directories.
	set backupdir=./.backup,~/.backup,~/tmp,/tmp,.	" Preference of backup directories.
	set backup						" Enable backups.

	" Save undo history.
	if has('persistent_undo')
		set undofile				" Enable persistent undo.
		set undolevels=2048			" Up to 2048 edits can be undone.
		set undoreload=16384		" Maximum number of lines to save in undo history if buffer is reloaded.
		set undodir=./.undo,~/.undo,~/tmp,/tmp/,.	" Preference of undo directories.
	endif


" File Format: Encoding, line endings, etc. {{{1
	set fileformats=unix,dos,mac	" Default to LF line endings for new files, but recognize all line endings.
	set fileencodings=ucs-bom,utf-8,default,latin1	" Default to UTF-8 with byte order marker.


" Code Blocks: Indentation, folding, tabs, etc. {{{1
	" Indentation And Tabs: {{{2
		set tabstop=4				" Raw tab characters stop every # columns.
		set softtabstop=4			" When inserting, insert spacechars so as to stop # columns.
		set shiftwidth=4			" Number of columns by which to indent with shift commands.
		set shiftround				" Round existing indentation upon reindentation.
		filetype plugin indent on	" Syntax-based automatic indentation.

	" Folding: {{{2
		set foldenable				" Enable folding features.
		set foldmethod=syntax		" Fold based on syntax.

		" Normal Mode - Spacebar toggles current fold if in fold; defaults to old spacebar behavior otherwise.
		nnoremap <silent> <Space> @=(foldlevel('.') ? 'za' : "\<Space>") <CR>


" Code Integration: Common language integration mechanisms, such as syntax highlighting. {{{1
	set modeline					" Read vim settings from comments at top/bottom of file.

	syntax enable					" Enable syntax highlighting and such.


" User Interface: Colors, line numbering, etc. {{{1
	set number						" Line numbering.
	set scrolloff=5					" Minimum number of lines to keep above/below cursor.
	set display=lastline			" Don't replace screen-overflowing lines with '@@@@'...
	set foldcolumn=5				" Width of the folding gutter.
	set cursorline					" Underline the active row.
	set nottyfast					" Only redraw updated parts of the screen.
	set showcmd						" Show info about last command/visual selection on bottom row.
	set mouse=a						" Enable the mouse, with automatic mode determination, in all modes.
	set history=1024				" Couldn't realistically use up this much history.
	set showmode					" Show current mode.  This is default with nocompatible, but reiterate.
	
	" For use with :mkview; specifies what to save
	if has('win32') || has('win64')
		" unix:		Use <NL> only in :mkview script.  UNIX vim can't source non-UNIX scripts.
		" slash:	Replace backslashes in file paths with forward slashes.
		set viewoptions=cursor,folds,options,unix,slash
	else
		set viewoptions=cursor,folds,options
	endif
	
	" Status Line: What the status line should look like. {{{2
		if has('statusline')
			set laststatus=2			" Always show the status line.

			" The status line contents; similar to spf13
			set statusline=%#WarningMsg#%w%h%#ErrorMsg#%r%*%m	" Read Only, Modified
			set statusline+=\ %<%f								" File Name
			set statusline+=\ [%{&ff}]%y						" File Format
			set statusline+=%=									" Start Right Align
			set statusline+=%{getcwd()}							" Current Working Directory
			set statusline+=\ \ %l,%c-%v%4.4p%%					" Cursor Position
		endif
	
	" Windows And Tabs: Windows, tabs, and buffers. {{{2
		set hidden					" Enable hidden buffers.
		
		if has('windows')
			set showtabline=2			" Always show tabs.
			set switchbuf=usetab,split	" Try to use an existing tab.  Compile errors go in split windows.
		endif
		
		" Move easily between panes with Alt-Arrow.
		nnoremap <silent> <C-k> :wincmd k<CR>
		nnoremap <silent> <C-j> :wincmd j<CR>
		nnoremap <silent> <C-h> :wincmd h<CR>
		nnoremap <silent> <C-l> :wincmd l<CR>


" General Commands: User Ex commands. {{{1
	command W call WriteAsSuperUser(@%)					" Write file as super-user.
	

" Helper Functions: Used by user Ex commands. {{{1
	function GetVimPath() " Gets the path to the vim executable. {{{2
		let l:path = expand('$_')
		
		if l:path =~# 'vim$'
			return l:path			" Use $_ environment variable (POSIX).
		else
			return 'vim'			" Attempt to use $PATH or %CD%.
		endif
	endfunction
	
	function GetNullDevice() " Gets the path to the null device. {{{2
		if filewritable('/dev/null')
			return '/dev/null'
		else
			return 'NUL'
		endif
	endfunction
	
	function WriteAsSuperUser(file) " Write buffer to a:file as the super user (on POSIX, root). {{{2
		exec '%write !sudo tee ' . shellescape(a:file, 1) . ' >' . GetNullDevice()
		redraw!
	endfunction


" }}}1
" EOF
