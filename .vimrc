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
set wildignore+=*/tmp/*,*/__pycache__/*,*.so,*.swp,*.pyc,*.pyo,*.gif,*.jpg,*.png

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

set splitbelow
set splitright

" Colorscheme {{{1
set background=dark

colorscheme onedark

" For 24bit support
function! RetoggleTermguicolors()
    " Disable 24-bit color when the most recent client is Panic Prompt 2,
    " which does not support it. Luckily for us, Prompt 2 sets the value of
    " TERM_PROGRAM when it connects. We look for this env var in the client
    " tmux's environ, if it is supported. Getting the client pid is only
    " supported starting from tmux 2.1.
    if len($TMUX) == 0
        let l:isprompt2 = $TERM_PROGRAM == "Prompt_2"
    else  " We are running inside tmux
        " We can't access client_pid: just give up for now
        if g:tmuxversion >= 21
            let l:tmuxclients = reverse(sort(systemlist("tmux list-clients -F \"#{client_activity} #{client_pid}\"")))[0]
            let l:activetmuxclient = split(l:tmuxclients)[1]
            let l:activeenviron = readfile("/proc/" . l:activetmuxclient . "/environ")
            let l:isprompt2 = match(l:activeenviron, "TERM_PROGRAM=Prompt_2") > -1
        else
            let l:isprompt2 = 1
        endif
    endif

    if l:isprompt2
        set notermguicolors
    else
        set termguicolors
    endif
endfunction

if has("termguicolors")
    let g:tmuxversion = substitute(system('tmux -V'), "[^0-9]", '', 'g')

    autocmd VimResized * call RetoggleTermguicolors()
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    call RetoggleTermguicolors()
endif

" Plugin options {{{1
" NERDTree {{{2
let NERDTreeChDirMode = 2
let NERDTreeMouseMode = 2
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
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#tab_nr_type = 1 " tabnr
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_splits = 0
" They're all tabs
let g:airline#extensions#tabline#show_tab_type = 0

" CtrlP {{{2
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']
let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
let g:ctrlp_match_window = 'results:50'
let g:ctrlp_tilde_homedir = 1
let g:ctrlp_mruf_relative = 1
let g:ctrlp_prompt_mappings = { 'ToggleMRURelative()': ['<F2>'] }  " What an unsatisfying map
" We never use buffer mode
let g:ctrlp_types = ['fil', 'mru']

" Tagbar {{{2
let g:tagbar_compact = 1
let g:tagbar_iconchars = ['+', '-']
" Fold imports and put them down there
let g:tagbar_foldlevel = 1
let g:tagbar_case_insensitive = 1
let g:tagbar_type_python = {
    \ 'kinds' : [
        \ 'c:classes',
        \ 'f:functions',
        \ 'm:members',
        \ 'v:variables:0:0',
    \ ],
\ }

" Syntastic {{{2
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_aggregate_errors = 1

let g:syntastic_python_checkers = ['flake8', 'mypy']
let g:syntastic_python_flake8_args = '--extend-ignore=E265,E301,E501,F812'
" SC2006: Use $() instead of legacy ``
" SC2046: Quote this to avoid word splitting
" SC2086: Double quote to prevent globbing and word splitting
let g:syntastic_sh_shellcheck_args = '-e SC2006 -e SC2046 -e SC2086'

" Rooter {{{2
let g:rooter_use_lcd = 1

" splitjoin {{{2

let g:splitjoin_python_brackets_on_separate_lines = 1
let g:splitjoin_trailing_comma = 1

" indentLine {{{2
let g:indentLine_concealcursor = ''

" Maps and other garbage {{{1

" Vim native functionality {{{2
let mapleader=","
set pastetoggle=<leader>p

" Anti-ideological navigation
nnoremap <leader>. :tabprevious<CR>
nnoremap <leader>/ :tabnext<CR>
for i in range(1, 9)
    execute "nnoremap <leader>" . i . " " . i . "gt"
endfor

" requirements.txt filetype
autocmd FileType requirements setlocal commentstring=#\ %s

" Command line abbrevation for current file's directory
" See http://vim.wikia.com/wiki/Easy_edit_of_files_in_the_same_directory
cabbr <expr> % expand('%:p:h')


" Plugin specific maps {{{2

" Tagbar: Set a shortcut for showing the tagbar.
nnoremap <leader>t :TagbarToggle<CR>

" Easymotion: Search two characters, either direction
map <leader>s <Plug>(easymotion-s2)

" OSC52: yank
vnoremap <leader>y y:call SendViaOSC52(getreg('"'))<CR>

" CtrlP: Fake :bro old
function! GlobalCtrlPMRU()
    " Hope no one will toggle MRU relative (make it go local -> global here)
    call ctrlp#mrufiles#tgrel()
    call ctrlp#init('mru')
    call ctrlp#mrufiles#tgrel()
endfunction

map <leader>m :call GlobalCtrlPMRU()<CR>
map <leader>b :CtrlPBuffer<CR>

" is: zv
" See https://github.com/haya14busa/incsearch.vim/issues/44,
" https://github.com/haya14busa/is.vim
let g:is#do_default_mappings = 0
map n <Plug>(is-n)zv
map n <Plug>(is-n)zv
map N <Plug>(is-N)zv
map * <Plug>(is-*)zv
map # <Plug>(is-#)zv
map g* <Plug>(is-g*)zv
map g# <Plug>(is-g#)zv

" Directory for undo file
silent !mkdir ~/.vim/undos > /dev/null 2>&1
set undodir=~/.vim/undos
set undofile

" Source .vimrc_local {{{1
if !empty(glob("~/.vimrc_local"))
    exec 'source' glob("~/.vimrc_local")
endif

" vim: foldmethod=marker foldlevel=0
