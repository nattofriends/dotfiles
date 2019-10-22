" Reference: https://github.com/joshdick/onedark.vim/blob/master/colors/onedark.vim

hi clear
syntax reset
let g:colors_name = "taxicab"
set background=light
set t_Co=256
hi Normal guifg=#000000 ctermbg=NONE guibg=#ffdf41 gui=NONE

" Syntax Groups
" Bold: keywords
hi Conditional guifg=#000000 guibg=NONE cterm=bold
hi Exception guifg=#000000 guibg=NONE cterm=bold
hi Function guifg=#000000 guibg=NONE cterm=bold
hi Identifier guifg=#000000 guibg=NONE cterm=bold
hi Label guifg=#000000 guibg=NONE cterm=bold
hi Operator guifg=#000000 guibg=NONE cterm=bold
hi Repeat guifg=#000000 guibg=NONE cterm=bold

" Italic: comments
" Comment and SpecialComment go together?
hi Comment guifg=#000000 guibg=#ffdf41 cterm=italic
hi SpecialComment guifg=#000000 guibg=#ffdf41 cterm=italic

" Inverted: data
hi Constant guifg=#ffdf41 guibg=#000000
hi Number guifg=#ffdf41 guibg=#000000
hi String guifg=#ffdf41 guibg=#000000

" Everything else
hi Debug guifg=#000000 guibg=NONE
hi Define guifg=#000000 guibg=NONE
hi Delimiter guifg=#000000 guibg=NONE
hi Error guifg=#000000 guibg=NONE
hi Include guifg=#000000 guibg=NONE
hi Keyword guifg=#000000 guibg=NONE
hi Macro guifg=#000000 guibg=NONE
hi MatchParen guifg=#000000 guibg=NONE
hi PMenuSel guifg=#000000 guibg=NONE
hi PreCondit guifg=#000000 guibg=NONE
hi PreProc guifg=#000000 guibg=NONE
hi Special guifg=#000000 guibg=NONE
hi SpecialChar guifg=#000000 guibg=NONE
hi Statement guifg=#000000 guibg=NONE
hi Storage guifg=#000000 guibg=NONE
hi Tag guifg=#000000 guibg=NONE
hi Title guifg=#000000 guibg=NONE
hi Todo guifg=#000000 guibg=NONE
hi Type guifg=#000000 guibg=NONE
hi WarningMsg guifg=#000000 guibg=NONE

" Highlighting Groups
hi ColorColumn guibg=#000000
" Skip: Conceal, Cursor, CursorIM
hi Conceal guibg=#ffdf41 guifg=#000000
hi CursorColumn guibg=#ffdf41 guifg=#000000

" No additional color for CursorLine, sorry.
hi CursorLine guifg=NONE guibg=NONE
hi CursorLineNr guifg=#ffdf41 guibg=#000000 cterm=NONE

hi Folded cterm=bold guibg=#ffdf41 guifg=#000000
hi LineNr cterm=italic guifg=#000000 guibg=#ffdf41

" Not defining IncSearch... how does it work?

" What is Pmenu? What are any of these things?
hi DiffAdd guifg=#000000 guibg=NONE
hi DiffChange guifg=#000000 guibg=NONE
hi DiffDelete guifg=#000000 guibg=NONE
hi DiffText guifg=#000000 guibg=NONE
hi Directory guifg=#000000 guibg=NONE
hi ErrorMsg guifg=#000000 guibg=NONE
hi MoreMsg guifg=#000000 guibg=NONE
hi NonText guifg=#000000 guibg=#ffdf41
hi Pmenu guifg=#000000 guibg=#ffdf41
hi SignColumn guibg=#ffdf41
hi SpecialKey guifg=#000000 guibg=NONE
hi Title guifg=#000000

hi StatusLine gui=bold guibg=#ffdf41 guifg=#000000
" Vim is going to do... something... since StatusLine and StatusLine are the
" same. Let's not worry about that
hi StatusLineNC gui=NONE guibg=#ffdf41 guifg=#000000

hi TabLine guifg=#000000 guibg=#ffdf41
hi TabLineFill guibg=#ffdf41
hi TabLineSel guifg=#ffdf41 guibg=#000000

hi Search guibg=#000000 guifg=#ffdf41
hi VertSplit gui=NONE guibg=#000000 guifg=#ffdf41
hi Visual guifg=#ffdf41 guibg=#000000

" For TagBar
hi TagBarVisibilityPublic guifg=#000000
