#!/usr/bin/env vim
" zn toggles folding.  za toggles an individual fold.  zR and zM expand and contract all folds.
" File Modeline Definition: {{{1
	" vim: ts=4 sw=4 sr sts=4 fdm=marker fmr={{{,}}} ff=unix fenc=utf-8 tw=130
	"	ts:		Actual tab character stops.
	"	sw:		Indentation commands shift by this much.
	"	sr:		Round existing indentation when using shift commands.
	"	sts:	Virtual tab stops while using tab key.
	"	fdm:	Folds are manually defined in file syntax.
	"	fmr:	Folds are denoted by {{{ and }}}.
	"	ff:		Line endings should always be <NL> (line feed #09).
	"	fenc:	Should always be UTF-8; #! must be first bytes, so no BOM.
	"	tw:		Maximum width of a line before it gets wrapped.
	
" Initialization: Standardize the options and set the right encoding. {{{1
	set nocompatible								" Enable non-vi-compatible features by default.

	scriptencoding utf-8							" This script is UTF-8 from here on.
	

" Helper Functions: Used by user Ex commands.  Must be toward the top. {{{1
	function s:GetVimPath() " Gets the path to the vim executable. {{{2
		let l:path == expand('$_')
		
		if l:path =~# 'vim$'
			return l:path			" Use $_ environment variable (POSIX).
		else
			return 'vim'			" Attempt to use $PATH or %CD%.
		endif
	endfunction
	
	function s:GetNullDevice(prefix) " Gets the path to the null device. {{{2
		if filewritable('/dev/null')
			return a:prefix . '/dev/null'
		elseif has('win32') || has('win64')
			return a:prefix . 'NUL'
		else
			return ''
		endif
	endfunction
	
	function WriteAsSuperUser(file) " Write buffer to a:file as the super user (on POSIX, root). {{{2
		exec '%write !sudo tee ' . shellescape(a:file, 1) . s:GetNullDevice(' >')
		redraw!
	endfunction

	function s:IsCmdExe() " Determines whether running within Windows' cmd.exe or command.com. {{{2
		" Unfortunately, we can't just test $COMSPEC, Cygwin keeps that as cmd.exe even through SSH.
		if match('[\\/](cmd.exe|command.com)$', $COMSPEC) > 0 && match('^cygwin', $TERM) > 0
			return 1
		else
			return 0
		endif
	endfunction

	function ToggleMouse() " Toggle mouse support {{{2
		if &mouse == ''
			if !exists('s:default_mouse')
				let s:default_mouse = 'a'
			endif

			let &mouse = s:default_mouse
		else
			let s:default_mouse = &mouse
			set mouse=
		endif
	endfunction


" Platform Independence: Sets the same basic defaults on all platforms. {{{1
	" Internal Encodings: Internal and output encoding, not write encoding. {{{2
		" These may need to be overridden  before editing very, very large files.  Preferred solution is modeline in file.
		" Example would be, "vim: fenc=latin1 enc=latin1"
		set encoding=utf-8							" Internal vim encoding.  Processed as UTF-8, but supports up to UCS-4.
		set termencoding=utf-8						" Encoding of vim output.
		set fileformats=unix,dos,mac				" Default to LF line endings for new files, but recognize all line endings.
		set fileencodings=ucs-bom,utf-8,latin1		" Default to UCS if BOM is set.  If UCS and UTF-8 error out, fallback to latin1.
		setglobal fileencoding=utf-8				" Default to utf-8 without BOM for new files, so as to preserve magic numbers, such as "#!".


	" Universal: Set the same values across all platforms that might otherwise vary. {{{2
		set backspace=indent,eol,start				" Some implementations don't have this as the default.

		let mapleader="\\"							" Used in place of <Leader>.

		" Try to integrate with system clipboard.
		if has('unnamedplus')
			set clipboard=unnamed,unnamedplus		" Export yanked text to the X11 clipboard.
		else
			set clipboard=unnamed					" Export yanked text to the only clipboard.
		endif

	" Embedded: Android, etc. {{{2
		" For the Android keyboard.  The key to the left of <End> sends <Nul>.
		" This can be fixed by hard-mapping 0 to <kHome>, but it's nice to have this as a backup.
		map <Nul> <Home>
		map! <Nul> <Home>

	" Windows: Fixes for Windows/MS-DOS. {{{2
		" Use .vim instead of vimfiles on Windows to make for easier transitions between systems.
		if has('win32') || has('win64')
			set runtimepath=~/.vim,$VIM/vimfiles,$VIMRUNTIME,~/.vim/after,$VIM/vimfiles/after
		endif

	" Mac: Fixes for OS X. {{{2
		" Home/End keybinding fix for Mac. Only required with default Terminal.app.   Custom terminals, such as iTerm, generally fix this.
		noremap <A-F> $
		noremap! <A-F> <C-O>$
		noremap <A-H> 0
		noremap! <A-H> <C-O>0


" Persistency And Redundancy: Version control, backups, undo history, saving marks, etc. {{{1
	set directory=./.swp,~/.swp,./.tmp,~/tmp,/tmp,.	" Preference of swap directories.
	set backupdir=./.backup,~/.backup,~/tmp,/tmp,.	" Preference of backup directories.
	set backup										" Enable backups.

	" '256	Save marks for previous 256 files.
	" <1024	Save up to 1024 lines for each register.
	" !		Save uppdercase global variables.
	" %		Restore buffer list when not passed a file to open.
	" /128	Save 128 search/substitute patterns.
	" :256	Save 256 command line items.
	" @256	Save 256 input lines.
	" c		Convert viminfo encoding to current encoding.
	" f1	Store file marks (uppercase and numbers).
	" h		Don't highlight old searches loaded from viminfo through hlsearch.
	" s100	Each register can be up to 100 KB.
	" r		Removable media and other temporary paths for which no marks should be stored.  Varies by OS.
	set viminfo='256,<1024,!,%,/128,:256,@256,c,f1,h,s100,r/tmp,r$HOME/tmp,r$HOME/.tmp,r/media
	if "$TEMP" != ''
		set viminfo+=r$TEMP
	endif
	if has('win32') || has('win64')
		set viminfo+=ra:,r/a/
	endif

	" Save undo history.  'persistent_undo' is a relatively new feature.
	set undolevels=2048								" Up to 2048 edits can be undone.
	if has('persistent_undo')
		set undofile								" Enable persistent undo.
		set undoreload=16384						" Maximum number of lines to save in undo history if buffer is reloaded.
		set undodir=./.undo,~/.undo,~/tmp,/tmp/,.	" Preference of undo directories.
	endif

	" Insert undo breaks frequently so that an undo doesn't rewind an entire insert mode session.
	inoremap <CR> <C-G>u<CR>
	inoremap <Space> <C-G>u<Space>
	inoremap . <C-G>u.
	inoremap <Tab> <C-G>u<Tab>
	inoremap <BS> <C-G>u<BS>


" Code Blocks: Indentation, folding, tabs, etc. {{{1
	" Indentation And Tabs: {{{2
		set tabstop=4								" Raw tab characters stop every # columns.
		set softtabstop=4							" When inserting, insert spacechars so as to stop # columns.
		set shiftwidth=4							" Number of columns by which to indent with shift commands.
		set shiftround								" Round existing indentation upon reindentation.

		filetype plugin indent on					" Syntax-based automatic indentation.

		" On second thought, I dislike this.  I end up Esc-ing back to normal more often.  It's easier to just use gv when I need
		" it.
		" " Don't exit visual mode when performing various operations.  (At least, re-enter it after exiting.)
		" " Shifting
		" vnoremap << <gv
		" vnoremap >> >gv
		" " Yoink/Plop
		" vnoremap y ygv
		" vnoremap p pgv
		" vnoremap P Pgv

	" Folding: Only the syntax fold settings.  Fold gutter goes under UI. {{{2
		set nofoldenable							" Disable folding by default. zi to toggle.
		set foldmethod=syntax						" Fold based on syntax.

		"Spacebar toggles current fold if in fold; defaults to old spacebar behavior otherwise.
		nnoremap <expr> <silent> <Space> (foldlevel('.') ? 'za' : "\<Space>")


" Code Integration: Common language integration mechanisms, such as syntax highlighting. {{{1
	set modeline									" Read vim settings from comments at top/bottom of file.
	set modelines=15								" Leave enough room to put header comments before modelines; don't do that, though.

	syntax enable									" Enable syntax highlighting and such.

	" Autocomplete: Various autocompletion mechanisms.  {{{2
		set completeopt=menu,menuone,preview		" Use a popup menu, show a menu even if only one completion, and show a preview.

		highlight Pmenu ctermbg=DarkBlue ctermfg=LightGray
		highlight PmenuSel ctermbg=DarkMagenta ctermfg=LightGray
		highlight PmenuSbar ctermbg=LightBlue ctermfg=DarkMagenta
		highlight PmenuThumb ctermbg=DarkMagenta ctermfg=LightMagenta

		" Autocomplete based on syntax highlighting for uncustomized files.
		if has('autocmd') && exists("+omnifunc")
			autocmd Filetype *
				\	if &omnifunc == '' |
				\		setlocal omnifunc=syntaxcomplete#Complete |
				\	endif
		endif


" User Interface: Colors, line numbering, etc. {{{1
	set number										" Line numbering.
	set scrolloff=4									" Minimum number of lines to keep above/below cursor.
	set display=lastline							" Don't replace screen-overflowing lines with '@@@@'...
	set nottyfast									" Only redraw updated parts of the screen.
	set showcmd										" Show info about last command/visual selection on bottom row.
	set history=1024								" Couldn't realistically use up this much history.
	set showmode									" Show current mode.  This is default with nocompatible, but reiterate.
	set foldcolumn=4								" Width of fold gutter.

	colorscheme peachpuff							" Basic color scheme; UI section can modify this.

	" For use with :mkview; specifies what to save
	set viewoptions=cursor,folds,options
	if has('win32') || has('win64')
		" unix:		Use <NL> only in :mkview script.  UNIX vim can't source non-UNIX scripts.
		" slash:	Replace backslashes in file paths with forward slashes.
		set viewoptions+=unix,slash
	endif

	" Specific to Windows' cmd.exe.
	if s:IsCmdExe()
		set nocursorline							" Looks horrible since cmd.exe doesn't support underline.
		set mouse=									" No mouse support in cmd.exe
	else
		set cursorline								" Underline the line in which the cursor lies.
		set mouse=a									" Enable the mouse, with automatic mode determination, in all modes.
	endif

	" Mappings to toggle the mouse.
	noremap <expr> <Leader>m ToggleMouse()

	" Status Line: What the status line should look like. {{{2
		if has('statusline')
			set laststatus=2						" Always show the status line.

			" The status line contents; similar to spf13
			set statusline=%#WarningMsg#%w%h		" Preview Window, Help File
			set statusline+=%#ErrorMsg#%r			" Read Only
			set statusline+=%*%m					" Modified
			set statusline+=\ %<%f					" File Name
			set statusline+=\ [%{&ff}]%y			" File Format
			set statusline+=\ co=%{&t_Co}			" Terminal Colors
			set statusline+=%=						" Start Right Align
			set statusline+=%<%{getcwd()}			" Current Working Directory
			set statusline+=\ \ %l,%c-%v%4.4p%%		" Cursor Position
		endif
	
	" Windows And Tabs: Windows, tabs, and buffers. {{{2
		set hidden					" Enable hidden buffers.
		
		if has('windows')
			set showtabline=2						" Always show tabs.
			set switchbuf=usetab,split				" Try to use an existing tab.  Compile errors go in split windows.

			" Move easily between panes with Ctrl + DirectionalLetter and Ctrl + Arrow.
			" <C-L> normally redraws the screen in normal mode.  Use :redraw instead.
			" <C-K> normally inserts the next key in <> notation.  Use <C-,> instead.
			" For digraphs, use {char1} <BS> {char2} (intrinsic feature).
			noremap <C-K> <C-W>k
			noremap <C-J> <C-W>j
			noremap <C-H> <C-W>h
			noremap <C-L> <C-W>l
			noremap <C-Up> <C-W>k
			noremap <C-Down> <C-W>j
			noremap <C-Left> <C-W>h
			noremap <C-Right> <C-W>l
			noremap! <C-K> <C-W>k
			noremap! <C-J> <C-W>j
			noremap! <C-H> <C-W>h
			noremap! <C-L> <C-W>l
			noremap! <C-Up> <C-W>k
			noremap! <C-Down> <C-W>j
			noremap! <C-Left> <C-W>h
			noremap! <C-Right> <C-W>l
			" Replace <C-K>.
			noremap <C-,> <C-K>
			noremap! <C-,> <C-K>
		endif


" Autocommands: Automatically called under certain conditions. {{{1
	if has('autocmd')
		" Automatically restore the last cursor position in a file.
		autocmd BufReadPost *
			\	if line('''"') >= 1 && line('''"') <= line('$') |
			\		exec 'normal! g''"' |
			\	endif
	endif


" Commands: User Ex commands. {{{1
	" Write file as super-user (root).
	command SudoW call WriteAsSuperUser(@%)

	" Commonly mistyped commands.
	command W w
	command Q q
	command WQ wq
	command WN wn

" Mappings: Keyboard shortcuts. {{{1
	" Visual And Select Modes: {{{2
	
	" Insert Mode: {{{2
		
	" Normal Mode: {{{2

" }}}1
" EOF
