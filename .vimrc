" Vim options {{{1
" Pathogen load
runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

filetype plugin indent on
syntax on

" Important in some environments...
set nocompatible

" In Windows it inherits the environment, i.e. cp932
set encoding=utf-8
set fileencoding=utf-8
set fileformats=unix,dos

" Better command-line completion
set wildmode=longest,list,full
set wildmenu
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc

" Show partial commands in the last line of the screen
set showcmd

" Highlight searches (use <C-L> to temporarily turn off highlighting; see the
" mapping of <C-L> below)
set hlsearch
set incsearch

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start

" When opening a new line and no filetype-specific indenting is enabled, keep
" the same indent as the line you're currently on. Useful for READMEs, etc.
set autoindent

" Stop certain movements from always going to the first character of a line.
" While this behaviour deviates from that of Vi, it does what most users
" coming from other editors would expect.
set nostartofline
" Display the cursor position on the last line of the screen or in the status
" line of a window
set ruler

" Always display the status line, even if only one window is displayed
set laststatus=2

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm

" Use visual bell instead of beeping when doing something wrong
set visualbell

" And reset the terminal code for the visual bell. If visualbell is set, and
" this line is also included, vim will neither flash nor beep. If visualbell
" is unset, this does nothing.
set t_vb=

" Enable use of the mouse for all modes
if has("mouse_sgr")
    set ttymouse=sgr
else
    set ttymouse=xterm2
end
set mouse=a

if has('gui_running')
    set guifont=Consolas:h9:cANSI:qDRAFT
    set guifontwide=MS_Gothic
    set lines=58
    set columns=213
    set guioptions-=T
    set guioptions-=t
    set guioptions+=c
    set iminsert=0
    set imsearch=0
    set noimcmdline
endif

" Set the command window height to 2 lines, to avoid many cases of having to
" "press <Enter> to continue"
set cmdheight=2

" Display line numbers on the left
set number

" Quickly time out on keycodes, but never time out on mappings
set notimeout ttimeout ttimeoutlen=200

set showmatch
set cursorline
hi cursorline cterm=NONE ctermbg=darkblue ctermfg=white guibg=darkgrey guifg=white
" set showmode

set lazyredraw

set nobomb

set showtabline=2

set expandtab       " Tab key indents with spaces
set tabstop=4       " display width of a physical tab character
set shiftwidth=0    " auto-indent (e.g. >>) width; 0 = use tabstop
set softtabstop=-1  " disable part-tab-part-space tabbing; < 0 = use tabstop

set relativenumber

set scrolloff=1

set list listchars=tab:>>,trail:.,precedes:<,extends:>

" Colorscheme {{{1
set background=dark

colorscheme onedark

" For 24bit support
function! RetoggleTermguicolors()
    if len($TMUX) == 0
        let l:isprompt2 = $TERM_PROGRAM == "Prompt_2"
    else  " We are running inside tmux
        let l:activeenviron = system("cat /proc/$(tmux list-clients -F \"#{client_activity} #{client_pid}\" | sort -r | head -n 1 | cut -d ' ' -f 2)/environ")
        let l:isprompt2 = match(l:activeenviron, "TERM_PROGRAM=Prompt_2") > -1
    endif

    if l:isprompt2
        set notermguicolors
    else
        set termguicolors
    endif
endfunction

if has("termguicolors")
    autocmd VimResized * call RetoggleTermguicolors()
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    call RetoggleTermguicolors()
endif

" Plugin options {{{1
" NERDTree {{{2
let NERDTreeChDirMode=2
let NERDTreeMouseMode=2
let NERDTreeIgnore = ['\.pyc$']
let g:nerdtree_tabs_focus_on_files=1
let g:nerdtree_tabs_open_on_gui_startup=0

" NERDCommenter {{{2
let g:NERDSpaceDelims = 1
" Left aligned linewise commenting.
let g:NERDDefaultAlign = 'left'
" Enable block commenting using triple-quoted strings via <Leader>cm
let g:NERDCustomDelimiters = { 'python': { 'left': '# ', 'leftAlt': '"""', 'rightAlt': '"""' } }

" Airline {{{2
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline#extensions#branch#enabled = 0

" CtrlP {{{2
let g:ctrlp_by_filename = 1
let g:ctrlp_working_path_mode = 'r'
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']
let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }

" Tagbar {{{2
let g:tagbar_compact = 1
let g:tagbar_iconchars = ['+', '-']
" Fold imports and put them down there
let g:tagbar_foldlevel = 1
let g:tagbar_type_python = {
    \ 'kinds' : [
        \ 'c:classes',
        \ 'f:functions',
        \ 'm:members',
        \ 'i:imports:1:0',
        \ 'v:variables:0:0',
    \ ],
\ }

" Syntastic {{{2
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_python_checkers = ['flake8']
let g:syntastic_python_flake8_args = '--ignore=E265,E301,E501,F812'
" SC2006: Use $() instead of legacy ``
" SC2046: Quote this to avoid word splitting
" SC2086: Double quote to prevent globbing and word splitting
let g:syntastic_sh_shellcheck_args = '-e SC2006 -e SC2046 -e SC2086'

" Rooter {{{2
let g:rooter_use_lcd = 1

" Maps and other garbage {{{1
let mapleader=","
set pastetoggle=<leader>p

" Some different <Esc> alternatives we can try...
inoremap jk <Esc>
inoremap ;; <Esc>
inoremap <Leader><Leader> <Esc>

" This unsets the "last search pattern" register by hitting return
nnoremap <CR> :noh<CR><CR>

" Set a shortcut for showing the tagbar.
nnoremap <leader>t :TagbarToggle <cr>

" Easymotion: Search two characters, either direction
nmap <leader>s <Plug>(easymotion-s2)

" Anti-ideological navigation
nnoremap <leader>. :tabprevious<CR>
nnoremap <leader>/ :tabnext<CR>
nnoremap <C-t> :tabnew<CR>
nnoremap <leader>1 1gt
nnoremap <leader>2 2gt
nnoremap <leader>3 3gt
nnoremap <leader>4 4gt
nnoremap <leader>5 5gt
nnoremap <leader>6 6gt
nnoremap <leader>7 7gt
nnoremap <leader>8 8gt
nnoremap <leader>9 9gt

" OSC 52 yank
vnoremap <leader>y y:call SendViaOSC52(getreg('"'))<CR>

" Tabby tabline
if exists("+showtabline")
  function! MyTabLine()
    let s = ''
    for i in range(tabpagenr('$'))
      " set up some oft-used variables
      let tab = i + 1 " range() starts at 0
      let winnr = tabpagewinnr(tab) " gets current window of current tab
      let buflist = tabpagebuflist(tab) " list of buffers associated with the windows in the current tab
      let bufnr = buflist[winnr - 1] " current buffer number
      let bufname = bufname(bufnr) " gets the name of the current buffer in the current window of the current tab

      let s .= '%' . tab . 'T' " start a tab
      let s .= (tab == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#') " if this tab is the current tab...set the right highlighting
      let s .= ' ' . tab " current tab number
      let n = tabpagewinnr(tab,'$') " get the number of windows in the current tab
      if n > 1
        let s .= ':' . n " if there's more than one, add a colon and display the count
      endif
      let bufmodified = getbufvar(bufnr, "&mod")
      if bufmodified
        let s .= ' +'
      endif
      if bufname != ''
        let s .= ' ' . pathshorten(bufname) . ' ' " outputs the one-letter-path shorthand & filename
      else
        let s .= ' [No Name] '
      endif
    endfor
    let s .= '%#TabLineFill#' " blank highlighting between the tabs and the righthand close 'X'
    let s .= '%T' " resets tab page number?
    let s .= '%=' " seperate left-aligned from right-aligned
    let s .= '%#TabLine#' " set highlight for the 'X' below
    let s .= '%999XX' " places an 'X' at the far-right
    return s
  endfunction
  set tabline=%!MyTabLine()
endif

" requirements.txt filetype
autocmd FileType requirements setlocal commentstring=#\ %s

" 20171203: The following maps seem to be infrequently used {{{2

" Toggling relative number mode.
nnoremap <silent><leader>n :set rnu! rnu? <cr>

" File browser
nnoremap <leader>f :NERDTreeTabsToggle <cr>

" Bidirectional search jump
command Pfve PairFileVSplitEdit

" Directory for undo file
silent !mkdir ~/.vim/undos > /dev/null 2>&1
set undodir=~/.vim/undos
set undofile

" Source .vimrc_local {{{2
if !empty(glob("~/.vimrc_local"))
    exec 'source' glob("~/.vimrc_local")
endif

" vim: foldmethod=marker foldlevel=0
