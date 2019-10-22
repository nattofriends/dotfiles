hi clear
syntax reset
let g:colors_name = "taxicab"
set background=light
set t_Co=256
hi Normal guifg=#000000 ctermbg=NONE guibg=#ffdf41 gui=NONE

" Syntax Groups
hi Comment guifg=#000000 cterm=italic
hi Conditional guifg=#000000 guibg=NONE cterm=bold
hi Constant guifg=#000000 guibg=NONE cterm=italic
hi Debug guifg=#000000 guibg=NONE
hi Define guifg=#000000 guibg=NONE
hi Delimiter guifg=#000000 guibg=NONE
hi DiffAdd guifg=#000000 guibg=NONE
hi DiffChange guifg=#000000 guibg=NONE
hi DiffDelete guifg=#000000 guibg=NONE
hi DiffText guifg=#000000 guibg=NONE
hi Directory guifg=#000000 guibg=NONE
hi Error guifg=#000000 guibg=NONE
hi ErrorMsg guifg=#000000 guibg=NONE
hi Exception guifg=#000000 guibg=NONE
hi Function guifg=#000000 guibg=NONE cterm=bold
hi Identifier guifg=#000000 guibg=NONE cterm=bold
hi IncSearch guifg=#000000 guibg=#ffdf41
hi Include guifg=#000000 guibg=NONE
hi Keyword guifg=#000000 guibg=NONE
hi Label guifg=#000000 guibg=NONE
hi Macro guifg=#000000 guibg=NONE
hi MatchParen guifg=#000000 guibg=NONE
hi MoreMsg guifg=#000000 guibg=NONE
hi Number guifg=#000000 guibg=NONE cterm=italic
hi Operator guifg=#000000 guibg=NONE
hi PMenuSel guifg=#000000 guibg=NONE
hi PreCondit guifg=#000000 guibg=NONE
hi PreProc guifg=#000000 guibg=NONE
hi Repeat guifg=#000000 guibg=NONE cterm=bold
hi Special guifg=#000000 guibg=NONE
hi SpecialKey guifg=#000000 guibg=NONE
hi SpecialChar guifg=#000000 guibg=NONE
hi SpecialComment guifg=#000000 guibg=#ffdf41 cterm=italic
hi Statement guifg=#000000 guibg=NONE
hi Storage guifg=#000000 guibg=NONE
hi String guifg=#000000 guibg=NONE
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
hi CursorLine guibg=#ffdf41 guifg=#000000
hi CursorLineNr guifg=#000000 guibg=NONE

hi Folded cterm=bold guibg=#ffdf41 guifg=#000000

" What is Pmenu?
hi Pmenu guifg=#000000 guibg=#ffdf41
hi SignColumn guibg=#ffdf41
hi Title guifg=#000000
hi LineNr cterm=italic guifg=#000000 guibg=#ffdf41
hi NonText guifg=#000000 guibg=#ffdf41

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
