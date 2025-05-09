"
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
set wildignore+=*/tmp/*,*/__pycache__/*,*/.mypy_cache/*,*.so,*.swp,*.pyc,*.pyo,*.gif,*.jpg,*.png

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

set ssop-=options
set ssop-=folds

" Make netrw less terrible
let loaded_nerd_tree = 1
let g:netrw_liststyle = 3
let g:netrw_banner = 0
let g:netrw_browse_split = 3

" Enable use of the mouse for all modes
if !has('nvim')
    if has("mouse_sgr")
        set ttymouse=sgr
    else
        set ttymouse=xterm2
    end
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

if &term =~ '256color'
  " disable Background Color Erase (BCE) so that color schemes
  " render properly when inside 256-color tmux and GNU screen.
  " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
  set t_ut=
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

autocmd BufRead * DetectIndent
autocmd FileType make set noexpandtab

set relativenumber

set scrolloff=1

set list

set updatetime=250
set signcolumn=yes
autocmd FileType tagbar,nerdtree,qf,twiggy,undotree,ctrlp setlocal signcolumn=no

let g:baselistchars = "tab:>>,trail:·,precedes:<,extends:>"
let &listchars = g:baselistchars
" Indent guide with (lead)multispace and reconfiguring when sw changes
" let g:multispacelistchars = "multispace:┆"
" let g:multispaceprefix = ""
" if has('patch-8.2.0959')
"     let g:multispaceprefix = "lead"
" endif
" let &listchars = g:baselistchars . ',' . g:multispaceprefix . g:multispacelistchars . '   '
" autocmd OptionSet shiftwidth execute 'setlocal listchars=' . g:baselistchars . ',' . g:multispaceprefix . g:multispacelistchars . repeat('\ ', &sw - 1)

set splitbelow
set splitright

set diffopt+=internal,algorithm:patience

" Colorscheme {{{1
" If something goes horribly wrong, still use the built in dark colors.
set background=dark

" Comments get italics. Vim considers TUI as cterm; Neovim reads gui.
autocmd ColorScheme * highlight Comment cterm=italic gui=italic

colorscheme taxicab

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
        if g:tmuxversion >= 21
            let l:tmuxclients = reverse(sort(systemlist("tmux list-clients -F \"#{client_activity} #{client_pid}\"")))[0]
            let l:activetmuxclient = split(l:tmuxclients)[1]

            let l:activeenviron = ""
            if g:platform == "Linux"
                let l:activeenviron = readfile("/proc/" . l:activetmuxclient . "/environ")
            elseif g:platform == "Darwin"
                let l:activeenviron = system("ps eww -o command= -p " . l:activetmuxclient)
            endif

            let l:isprompt2 = match(l:activeenviron, "TERM_PROGRAM=Prompt_2") > -1
        else
            " We can't access client_pid: just give up for now
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
    let g:platform = system("uname")

    autocmd VimResized * call RetoggleTermguicolors()
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    call RetoggleTermguicolors()
endif

" Hide filename if it's a loclist (should be always)
if has('patch-8.2.0959')
    "https://stackoverflow.com/questions/11199068/how-to-format-vim-quickfix-entries
    function! CompactQFTF(info)
        let ll = getloclist(a:info.winid, {'id': a:info.id, 'items': 0}).items
        let lnum_width = range(a:info.start_idx - 1, a:info.end_idx - 1)
            \ ->map({_, v -> ll[v].lnum})->max()->len()
        let col_width = range(a:info.start_idx - 1, a:info.end_idx - 1)
            \ ->map({_, v -> ll[v].col})->max()->len()
        let lnum_col_width = lnum_width + col_width + 1
        let formatted_lines = []
        for idx in range(a:info.start_idx - 1, a:info.end_idx - 1)
            let e = ll[idx]
            let fname = a:info.quickfix == 0 ? "" : bufname(e.bufnr)
            let line = printf('%s|% *s:% *s| %s', fname, lnum_width, e.lnum, col_width, e.col, e.text)
            call add(formatted_lines, line)
        endfor
        return formatted_lines
    endfunction

    let &quickfixtextfunc = 'CompactQFTF'
endif

function! StripTrailingWhitespace()
  if !&binary && &filetype != 'diff'
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
  endif
endfun

autocmd BufWritePre * | :call StripTrailingWhitespace()

" Plugin options {{{1
" NERDTree {{{2
let NERDTreeShowHidden = 1
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
let g:ctrlp_mruf_exclude = '\.git/COMMIT_EDITMSG|\.git/MERGE_MSG'
let g:ctrlp_mruf_relative = 1
let g:ctrlp_prompt_mappings = { 'ToggleMRURelative()': ['<F2>'] }  " What an unsatisfying map
let g:ctrlp_types = ['fil', 'mru', 'buf']

" Tagbar {{{2
let g:tagbar_compact = 1

for ctags in ['/usr/bin/ctags-universal', '/opt/homebrew/bin/ctags']
    if filereadable(ctags)
        let g:tagbar_ctags_bin = ctags
        break
    endif
endfor

let g:tagbar_iconchars = ['+', '-']
" Fold imports and put them down there
let g:tagbar_foldlevel = 1
let g:tagbar_case_insensitive = 1
let g:tagbar_show_visibility = 0

let g:tagbar_type_groovy = {
    \ 'kinds': [
        \ 'p:package:1',
        \ 'c:classes',
        \ 'i:interfaces',
        \ 't:traits',
        \ 'e:enums',
        \ 'm:methods',
        \ 'f:fields:1'
    \ ]
\ }
let g:tagbar_type_python = {
    \ 'kinds': [
        \ 'c:classes',
        \ 'f:functions',
        \ 'm:members',
        \ 'v:variables:0:0',
    \ ],
\ }

" close macros fold by default
let g:tagbar_type_make = {
    \ 'kinds': [
        \ 'm:macros:1',
        \ 't:targets'
    \ ]
\ }
let g:tagbar_type_terraform = {
    \ 'ctagstype': 'terraform',
    \ 'kinds': [
        \ 'r:resources',
        \ 'd:data',
        \ 'v:variables',
        \ 'p:providers',
        \ 'o:outputs',
        \ 'm:modules',
        \ 'f:tfvars'
    \ ],
\ }
let g:tagbar_type_yaml = {
    \ 'ctagsbin': 'yamlctags',
    \ 'ctagsargs': '',
    \ 'kinds': [
        \ 'i:items'
    \ ]
\ }
let g:tagbar_type_jinja = {
    \ 'ctagstype': 'jinja',
    \ 'kinds': [
        \ 'i:imports',
        \ 'm:macros',
        \ 'b:blocks',
    \ ],
\ }

" ALE {{{2
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_insert_leave = 0
let g:ale_fix_on_save = 1
let g:ale_open_list = 1

let g:ale_echo_msg_format = '%severity%: %linter%: %code: %%s'

call ale#handlers#cspell#DefineLinter('groovy')
let g:ale_linters = {
\   'groovy': ['cspell', 'npm-groovy-lint'],
\}

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'python': ['autopep8'],
\}

let g:ale_python_auto_virtualenv = 1
let g:ale_virtualenv_dir_names = ['venv', 'virtualenv_run']

let g:ale_cspell_options = '--config ~/.config/cspell/cspell.yaml'
" Disable shellcheck
let g:ale_sh_shellcheck_executable = '/dev/null'

let g:ale_groovy_npmgroovylint_options = '-r "LineLength{\"length\": 999}"'

let g:ale_python_autopep8_options = '--ignore=E401,E402,E501,W503,W504 --max-line-length=999'
let g:ale_python_black_options = '--line-length=999'
let g:ale_python_flake8_options = '--max-line-length=999 --extend-ignore=E203,W391,W503,W504'
let g:ale_python_isort_options = '--profile=black --force-single-line-imports --line-length=999 --float-to-top'

let g:ale_yaml_yamllint_options = '-d "{extends: relaxed, rules: {line-length: {max: 999}, indentation: disable, hyphens: disable}}"'

" Rooter {{{2
let g:rooter_cd_cmd = "lcd"

" For Terraform
let g:rooter_patterns = ['terraform.tfvars', '.git', '.git/']

" splitjoin {{{2
let g:splitjoin_python_brackets_on_separate_lines = 1
let g:splitjoin_trailing_comma = 1

" indentLine {{{2
let g:indentLine_concealcursor = ''
let g:indentLine_setColors = 0

" undotree {{{2
let g:undotree_DiffAutoOpen = 0
let g:undotree_DiffCommand = 'diff -u'
let g:undotree_ShortIndicators = 1
let g:undotree_SetFocusWhenToggle = 1

" Make not inverted in taxicab
hi def link UndotreeNode   Statement
hi def link UndotreeBranch Statement

" Twiggy
let g:twiggy_local_branch_sort = 'mru'
let g:twiggy_num_columns = 35
let g:twiggy_remote_branch_sort = 'date'
let g:twiggy_show_full_ui = 0
let g:twiggy_icons = ['*', '=', '+', '-', '~', '%', 'x']

" Maps and other garbage {{{1

" Vim native functionality {{{2
let mapleader=","
set pastetoggle=<leader>p

" Anti-ideological navigation
nnoremap <silent> <leader>. :tabprevious<CR>
nnoremap <silent> <leader>/ :tabnext<CR>
for i in range(1, 9)
    execute "nnoremap <silent> <leader>" . i . " " . i . "gt"
endfor

cnoreabbrev qw wq
cnoreabbrev qwa wqa

" Delete until space
nmap <leader>d dT x
" Copy this import
nmap <leader>ic Yp$dT xA

" Send to delete register
nnoremap x "_x
nnoremap dd "_dd
vnoremap d "_d

" requirements.txt filetype
autocmd FileType requirements setlocal commentstring=#\ %s

" Make CtrlPBuffer usable
autocmd BufRead * setlocal bufhidden=delete

" Command line abbrevation for current file's directory
" See http://vim.wikia.com/wiki/Easy_edit_of_files_in_the_same_directory
cabbr <expr> % expand('%:p:h')

" Oddly specific, surely we can do better than this
"
function! OpenContainingDirectory()
    let l:dir = expand('%:p:h')
    execute 'tabedit ' . l:dir
endfunction

map <leader>e :call OpenContainingDirectory()<CR>

function PasteOverEmpty()
    let l:isempty = getline('.') =~ '^\s*$'
    normal! p
    if l:isempty
        normal! "_dvk
    endif
endfunction

" Open all files in the argument list in tabs.
augroup open-tabs
    au!
    if has('patch-8.2.3888')
        au VimEnter * ++nested if !&diff | argded | tab all | tabfirst | endif
    else
        au VimEnter * ++nested if !&diff | tab all | tabfirst | endif
    endif
augroup end

nnoremap <silent> p :call PasteOverEmpty()<CR>


" Plugin specific maps {{{2

" Tagbar: Set a shortcut for showing the tagbar.
nnoremap <silent> <leader>t :TagbarToggle<CR>

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

map <silent> <leader>o :call GlobalCtrlPMRU()<CR>
map <leader>m :CtrlPMRUFiles<CR>
map <leader>b :CtrlPBuffer<CR>

" is: zv
" See https://github.com/haya14busa/incsearch.vim/issues/44,
" https://github.com/haya14busa/is.vim
" http://vimdoc.sourceforge.net/htmldoc/options.html#'foldopen'
"   NOTE: When the command is part of a mapping this option is not used.
"   Add the |zv| command to the mapping to get the same effect.
"   (rationale: the mapping may want to control opening folds
"   itself)
let g:is#do_default_mappings = 0
map n <Plug>(is-n)zv
map n <Plug>(is-n)zv
map N <Plug>(is-N)zv
map * <Plug>(is-*)zv
map # <Plug>(is-#)zv
map g* <Plug>(is-g*)zv
map g# <Plug>(is-g#)zv

" ArgWrap: no default bindings
nmap <silent> <leader>a <Plug>(ArgWrapToggle)

" Directory for undo file
silent !mkdir ~/.vim/{undos,swap,backup} > /dev/null 2>&1
let &undodir=$HOME . '/.vim/undos'
let &undodir=expand("~/.vim/undos")
set undofile
let &directory=expand("~/.vim/swap")
let &backupdir=expand("~/.vim/backup")

" Undotree
nnoremap <leader>u :UndotreeToggle<cr>

" Undotree
nnoremap <leader>u :UndotreeToggle<cr>

" Twiggy
autocmd BufNewFile,BufReadPost,VimEnter * call FugitiveDetect()
map <leader>b :Twiggy<CR>

" Source .vimrc_local {{{1
if !empty(glob("~/.vimrc_local"))
    exec 'source' glob("~/.vimrc_local")
endif

" Version support tables
" Ubuntu Bionic: 8.0.1453
" Ubuntu Focal: 8.1.2269
" Ubuntu Jammy: 8.2.3995
" Ubuntu Noble: 9.1.0016
" Debian Buster: 8.1.0875
" Debian Bullseye: 8.2.2434
" Debian Bookworm: 9.0.1378
" vim: foldmethod=marker foldlevel=0
