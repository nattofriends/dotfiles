" Pathogen load
filetype off

call pathogen#infect()
call pathogen#helptags()

" Better command-line completion
set wildmode=longest,list,full
set wildmenu

" Show partial commands in the last line of the screen
set showcmd

" Highlight searches (use <C-L> to temporarily turn off highlighting; see the
" mapping of <C-L> below)
set hlsearch
set incsearch
set ignorecase
set smartcase

filetype plugin indent on
syntax on

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
set ttymouse=xterm2
set mouse=a

" Set the command window height to 2 lines, to avoid many cases of having to
" "press <Enter> to continue"
set cmdheight=2

" Display line numbers on the left
set number

" Quickly time out on keycodes, but never time out on mappings
set notimeout ttimeout ttimeoutlen=200

" Use <F11> to toggle between 'paste' and 'nopaste'
" set pastetoggle=<F11>

set showmatch
set cursorline
hi cursorline cterm=NONE ctermbg=darkblue ctermfg=white guibg=darkgrey guifg=white
" set showmode

set lazyredraw

set nobomb

set background=dark
" colors monokai

let g:nerdtree_tabs_open_on_console_startup=1

set showtabline=2

function YelpSettings()
    setlocal noexpandtab    " don't turn them into spaces
    setlocal shiftwidth=4   " auto-indent width
    setlocal tabstop=4      " display width of a physical tab character
    setlocal softtabstop=0  " disable part-tab-part-space tabbing
endfunction
autocmd BufNewFile,BufRead $HOME/pg/* call YelpSettings()

let NERDTreeChDirMode=2

let g:pymode_lint_checker = "pyflakes"
let g:pymode_lint_cwindow = 0

"This unsets the "last search pattern" register by hitting return
nnoremap <CR> :noh<CR><CR>