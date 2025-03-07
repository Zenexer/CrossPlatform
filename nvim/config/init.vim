#!/usr/bin/env nvim
" zn toggles folding.  za toggles an individual fold.  zR and zM expand and contract all folds.
" File Modeline Definition: {{{1
	" vim: noet ts=4 sw=4 sr sts=4 fdm=marker fmr={{{,}}} ff=unix fenc=utf-8 tw=130
	" 	noet:	Don't expand tabs to spaces
	"	ts:		Actual tab character stops.
	"	sw:		Indentation commands shift by this much.
	"	sr:		Round existing indentation when using shift commands.
	"	sts:	Virtual tab stops while using tab key.
	"	fdm:	Folds are manually defined in file syntax.
	"	fmr:	Folds are denoted by {{{ and }}}.
	"	ff:		Line endings should always be <NL> (line feed #09).
	"	fenc:	Should always be UTF-8; #! must be first bytes, so no BOM.
	"	tw:		Maximum width of a line before it gets wrapped.

" TODO Investigate these in help: 'digraph', 'timeoutlen', 'ttimeoutlen'

" Initialization: Standardize options/encoding, set up environment. {{{1
	" Cache environment.
	let s:env_ostype = system('echo $OSTYPE')
	let s:env_comspec = system('echo $COMSPEC')
	let s:env_term = $TERM

	scriptencoding utf-8							" This script is UTF-8.

	let s:vimdir = fnamemodify(resolve(expand('<sfile>:p')), ':h')
	

" Helper Functions: Used by user Ex commands.  Must be toward the top. {{{1
	function Null(trash) " A no-op.  Returns '' instead of 0 (the default), so as not to cause problems with <expr> mappings. {{{2
		return ''
	endfunction

	function s:HasFlag(value, flag) " Tests if a number has a flag. {{{2
		if exists('*and')
			return and(a:value, a:flag) != 0
		else
			return a:value % (a:flag * 2) >= a:flag
		end
	endfunction

	function s:GetVimPath() " Gets the path to the vim executable. {{{2
		let l:path = $_
		
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
		if match(s:env_comspec, '[\\/](cmd.exe|command.com)$') >= 0 && s:IsCygwin()
			return 1
		else
			return 0
		endif
	endfunction

	function s:IsCygwin() " Determine whether we're running within Cygwin.  vim + cygwin = funk {{{2
		return match(s:env_ostype, 'cygwin') >= 0
	endfunction

	function s:AppendRtp(dir) " Append a:dir, a folder in s:vimdir, to &runtimepath.  Assumes that a:dir is raw (net yet escaped). {{{2
		let &runtimepath .= ',' . escape(s:vimdir . '/' . a:dir, '\,')
	endfunction

	function ToggleMouse() " Toggle mouse support {{{2
		if empty(&mouse)
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
	" Universal: Set the same values across all platforms that might otherwise vary. {{{2
		let mapleader="\\"							" Used in place of <Leader>.

	" Embedded: Android, etc. {{{2
		" For the Android keyboard.  The key to the left of <End> sends <Nul>.
		" This can be fixed by hard-mapping 0 to <kHome>, but it's nice to have this as a backup.
		map <Nul> <Home>
		map! <Nul> <Home>

	" Mac: Fixes for OS X. {{{2
		" Home/End keybinding fix for Mac. Only required with default Terminal.app.   Custom terminals, such as iTerm, generally fix this.
		noremap <A-F> $
		noremap! <A-F> <C-O>$
		noremap <A-H> 0
		noremap! <A-H> <C-O>0


" Persistency And Redundancy: Version control, backups, undo history, saving marks, etc. {{{1
	set directory=~/.local/share/nvim/swap,/tmp,.	" Preference of swap directories.
	set backupdir=~/.local/share/nvim/backup,/tmp,.	" Preference of backup directories.
	set backup										" Enable backups.

	" '256	Save marks for previous 256 files.
	" <1024	Save up to 1024 lines for each register.
	" !		Save uppercase global variables.
	" %		Restore buffer list when not passed a file to open.
	" /128	Save 128 search/substitute patterns.
	" :256	Save 256 command line items.
	" @256	Save 256 input lines.
	" f1	Store file marks (uppercase and numbers).
	" h		Don't highlight old searches loaded from viminfo through hlsearch.
	" s100	Each register can be up to 100 KB.
	" r		Removable media and other temporary paths for which no marks should be stored.  Varies by OS.
	set viminfo='256,<1024,!,%,/128,:256,@256,f1,h,s100,r/tmp,r$HOME/tmp,r$HOME/.tmp,r/media
	if "$TMPDIR" != ''
		set viminfo+=r$TMPDIR
	endif
	if has('win32') || has('win64')
		set viminfo+=ra:,r/a/
	endif

	" Save undo history.  'persistent_undo' is a relatively new feature.
	set undolevels=2048								" Up to 2048 edits can be undone.
	if has('persistent_undo')
		set undofile								" Enable persistent undo.
		set undoreload=16384						" Maximum number of lines to save in undo history if buffer is reloaded.
		set undodir=~/.local/share/nvim/undo,/tmp,.	" Preference of undo directories.
	endif

	" Insert undo breaks frequently so that an undo doesn't rewind an entire insert mode session.
	inoremap <CR> <C-G>u<CR>
	"inoremap <Space> <C-G>u<Space>
	"inoremap . <C-G>u.
	"inoremap <Tab> <C-G>u<Tab>
	"inoremap <BS> <C-G>u<BS>


" Code Blocks: Indentation, folding, tabs, etc. {{{1
	" Indentation And Tabs: {{{2
		set tabstop=4								" Raw tab characters stop every # columns.
		set softtabstop=4							" When inserting, insert spacechars so as to stop # columns.
		set shiftwidth=4							" Number of columns by which to indent with shift commands.
		set shiftround								" Round existing indentation upon reindentation.
		set copyindent								" Copy previous line's tab/space combination.

	" Folding: Only the syntax fold settings.  Fold gutter goes under UI. {{{2
		set nofoldenable							" Disable folding by default. zi to toggle.
		set foldmethod=syntax						" Fold based on syntax.

		" Spacebar toggles current fold if in fold; defaults to old spacebar behavior otherwise.
		nnoremap <expr> <silent> <Space> (foldlevel('.') ? 'za' : "\<Space>")


" Code Integration: Common language integration mechanisms, such as syntax highlighting. {{{1
	set modeline									" Read vim settings from comments at top/bottom of file.
	set modelines=5									" Leave enough room to put header comments before modelines; don't do that, though.

	" Syntax Specific: Individual languages. {{{2
		" PHP: {{{3
			"let g:php_folding=1                    " Enable syntax-based folding.  Disabled because it breaks syntax
			                                        "   highlighting.   

	" Syntax Enable: Needs to run after language-specifc. {{{2
		filetype on									" Enable filetype detection scripts.
		filetype plugin on							" Enable filetype plugin scripts.
		filetype indent on							" Enable syntax-based automatic indentation.
		syntax enable								" Enable syntax highlighting and such.


" User Interface: Colors, line numbering, etc. {{{1
	set nonumber									" Disable line numbering.
	"set display=lastline							" Don't replace screen-overflowing lines with '@@@@'... (Update: This seems to
													"   have a negative impact on performance.)
	set showcmd										" Show info about last command/visual selection on bottom row.
	set history=1024								" Couldn't realistically use up this much history.
	set showmode									" Show current mode.  This is default with nocompatible, but reiterate.
	set foldcolumn=0								" Width of fold gutter.
	
	if has('extra_search')
		set hlsearch								" Highlight matched searches.  Use <C-\>/, <C-/>, or \/ to clear.
	endif

	" Disabled to use platform defaults.
	"colorscheme torte								" Basic color scheme.  Normally overridden by bundles/includes.
	set background=light
	set termguicolors

	" For use with :mkview; specifies what to save
	set viewoptions=cursor,folds,options
	if has('win32') || has('win64')
		" unix:		Use <NL> only in :mkview script.  UNIX vim can't source non-UNIX scripts.
		" slash:	Replace backslashes in file paths with forward slashes.
		set viewoptions+=unix,slash
	endif

	" Specific to Windows' cmd.exe.
	" Note that these restrictions have been lifted in Windows 10 Anniversary, but I'm not sure whether neovim/msys2/cygwin
	" supports them yet.
	if s:IsCmdExe()
		"set nocursorline							" Looks horrible since cmd.exe doesn't support underline.
		set mouse=									" No mouse support in cmd.exe
	else
		"set cursorline								" Underline the line in which the cursor lies.
		set nocursorline							" This can get annoying, so disable it by default.
		"let s:default_mouse = 'a'					" Enable the mouse, with automatic mode determination, in all modes.
		let s:default_mouse = ''					" Disable the mouse by default.
		let &mouse = s:default_mouse
	endif

	" Status Line: What the status line should look like. {{{2
		if has('statusline')
			set laststatus=2						" Always show the status line.

			" The status line contents; similar to spf13
			" TODO Better color scheme
			set statusline=%#WarningMsg#%w%h		" Preview Window, Help File
			set statusline+=%#ErrorMsg#%r			" Read Only
			set statusline+=%#Comment#              " Color for the rest of the status line
			set statusline+=%m						" Modified
			set statusline+=\ %<%f					" File Name
			set statusline+=\ [%{&ff}]%y			" File Format
			set statusline+=\ t_Co=%{&t_Co}			" Terminal Colors
			set statusline+=%=						" Start Right Align
			set statusline+=%<%{getcwd()}			" Current Working Directory
			set statusline+=\ \ %l,%c-%v%4.4p%%		" Cursor Position
		endif
	
	" Windows And Tabs: Windows, tabs, and buffers. {{{2
		set hidden									" Enable hidden buffers.
		
		if has('windows')
			"set showtabline=2						" Always show tabs.
			set switchbuf=usetab,split				" Try to use an existing tab.  Compile errors go in split windows.
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
	command QA qa
	command WA wa


" Mappings: Keyboard shortcuts. {{{1
	" Repeat Substitute: Repeat the last substitution.  Unlike default, keep flags. {{{2
		nnoremap & :&&<CR>
		vnoremap & :s//~/&<CR>

	" Windows: Move easily between panes with Ctrl + Arrow. {{{2
		noremap <C-Up> <C-W><Up>
		noremap <C-Down> <C-W><Down>
		noremap <C-Left> <C-W><Left>
		noremap <C-Right> <C-W><Right>
		
		noremap! <C-Up> <C-W><Up>
		noremap! <C-Down> <C-W><Down>
		noremap! <C-Left> <C-W><Left>
		noremap! <C-Right> <C-W><Right>
		
	" Line Navigation: Move one visual line at a time, instead of one file line. {{{2
		vnoremap <silent> j gj
		vnoremap <silent> <Down> g<Down>
		vnoremap <silent> k gk
		vnoremap <silent> <Up> g<Up>

		noremap <silent> j gj
		noremap <silent> <Down> g<Down>
		noremap <silent> k gk
		noremap <silent> <Up> g<Up>
		
		inoremap <silent> <Down> <C-\><C-o>g<Down>
		inoremap <silent> <Up> <C-\><C-o>g<Up>

	" Mouse Toggle: Use <C-\>m or \m to toggle mouse support. {{{2
	" For custom mappings, map to: <SID>CrossPlatform-ToggleMouse
		noremap <expr><unique> <SID>CrossPlatform-ToggleMouse Null(ToggleMouse())
		noremap! <expr><unique> <SID>CrossPlatform-ToggleMouse Null(ToggleMouse())

		noremap <script><unique> <C-\>m <SID>CrossPlatform-ToggleMouse
		noremap! <script><unique> <C-\>m <SID>CrossPlatform-ToggleMouse
		nnoremap <script><unique> <Leader>m <SID>CrossPlatform-ToggleMouse
		vnoremap <script><unique> <Leader>m <SID>CrossPlatform-ToggleMouse

	" Line Duplication: Use <C-d>, <C-\>d, \d to duplicate a line. {{{2
	" For custom mappings, map to: <SID>CrossPlatform-Duplicate
		noremap <unique> <SID>CrossPlatform-Duplicate :copy .<CR>
		noremap! <script><unique> <SID>CrossPlatform-Duplicate <C-\><C-o><SID>CrossPlatform-Duplicate
		vunmap <SID>CrossPlatform-Duplicate
		" This gets turned into :'<'>copy '> because '<'> is automatically added after typing :.
		vnoremap <script><unique> <SID>CrossPlatform-Duplicate :copy '><CR>

		vnoremap <unique><script> <C-\>d <SID>CrossPlatform-Duplicate
		vnoremap <unique><script> <Leader>d <SID>CrossPlatform-Duplicate
		vnoremap <script> <C-d> <SID>CrossPlatform-Duplicate

		nnoremap <unique><script> <C-\>d <SID>CrossPlatform-Duplicate
		nnoremap <unique><script> <Leader>d <SID>CrossPlatform-Duplicate
		nnoremap <script> <C-d> <SID>CrossPlatform-Duplicate

		inoremap <unique><script> <C-\>d <SID>CrossPlatform-Duplicate
		inoremap <script> <C-d> <SID>CrossPlatform-Duplicate

	" Clear Search Highlighting: Use <C-/>, <C-\>/, or \/ to clear search highlighting. {{{2
	" <C-/> is typically sent as <C-_>, and will only be available if &allowrevins is disabled.
	" For custom mappings, map to: <SID>CrossPlatform-ClearSearch
		noremap <unique> <SID>CrossPlatform-ClearSearch :nohlsearch<CR>
		noremap! <script><unique> <SID>CrossPlatform-ClearSearch <C-\><C-o><SID>CrossPlatform-ClearSearch

		noremap <unique><script> <C-\>/ <SID>CrossPlatform-ClearSearch
		noremap <unique><script> <Leader>/ <SID>CrossPlatform-ClearSearch
		noremap <script> <C-/> <SID>CrossPlatform-ClearSearch

		noremap! <unique><script> <C-\>/ <SID>CrossPlatform-ClearSearch

		noremap <script> <C-/> <SID>CrossPlatform-ClearSearch
		noremap! <script> <C-/> <SID>CrossPlatform-ClearSearch
		if !(has('rightleft') && &allowrevins)
			noremap <script> <C-_> <SID>CrossPlatform-ClearSearch
			noremap! <script> <C-_> <SID>CrossPlatform-ClearSearch
		endif


" Include: Primarily bundles and includes. {{{1
	call s:AppendRtp('runtime')


" EOF
