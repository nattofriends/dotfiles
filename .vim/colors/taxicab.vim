" Reference: https://github.com/joshdick/onedark.vim/blob/master/colors/onedark.vim
" Color reference: https://mutcd.fhwa.dot.gov/kno-colorspec.htm
" Remember, vim treats TUI as cterm and neovim treats as gui

hi clear
syntax reset
let g:colors_name = "taxicab"
set background=light
set t_Co=256

" Combine cterm and gui since it's 2019
" Yeah, guisp is not supported
function! s:h(group, style)
    let l:args = ''
    if has_key(a:style, "fg")
        let l:args .= ' ' . 'guifg=' . a:style.fg.gui . ' ' . 'ctermfg=' . a:style.fg.cterm
    endif
    if has_key(a:style, "bg")
        let l:args .= ' ' . 'guibg=' . a:style.bg.gui . ' ' . 'ctermbg=' . a:style.bg.cterm
    endif
    if has_key(a:style, "attrs")
        let l:args .= ' ' . 'gui=' . a:style.attrs . ' ' . 'cterm=' . a:style.attrs
    endif
    execute "highlight" a:group l:args
endfunction

" XXX: cterm values untested
let s:none = { "gui": "NONE", "cterm": "NONE" }
let s:black = { "gui": "#000000", "cterm": "16" }
let s:yellow = { "gui": "#ffcd00", "cterm": "220" }

let s:normal = { "fg": s:black, "bg": s:yellow }
let s:reverse = { "fg": s:yellow, "bg": s:black }

call s:h("Normal", s:normal)

" Syntax Groups (Highlight groups for common language items) {{{1
" http://vimdoc.sourceforge.net/htmldoc/syntax.html#{group-name}
" Bold: keywords
for highlight_group in ["Conditional", "Exception", "Function", "Identifier", "Label", "Operator", "Repeat"]
    call s:h(highlight_group, extend(copy(s:normal), { "attrs": "bold" }))
endfor

" Italic: comments
" Comment and SpecialComment go together?
for highlight_group in ["Comment", "SpecialComment"]
    call s:h(highlight_group, extend(copy(s:normal), { "attrs": "italic" }))
endfor

" Inverted: data
for highlight_group in ["Constant", "Number", "String"]
    call s:h(highlight_group, s:reverse)
endfor

" Everything else
for highlight_group in [
    \"Debug", "Define", "Delimiter", "Error", "Include", "Keyword", "Macro", "MatchParen",
    \"PreCondit", "PreProc", "Special", "SpecialChar", "Statement", "Storage", "Tag",
    \"Title", "Todo", "Type", "Underlined"
\]
    call s:h(highlight_group, s:normal)
endfor

" Highlighting Groups (non-syntax) {{{1
" http://vimdoc.sourceforge.net/htmldoc/syntax.html#highlight-groups

for highlight_group in [
    \"Conceal", "DiffText", "Directory", "Folded", "LineNr", "MoreMsg", "NonText",
    \"PMenuSel", "PMenuSbar", "SignColumn", "SpecialKey", "TabLine", "WildMenu"
\]
    call s:h(highlight_group, s:normal)
endfor

" Inverted
" Note: The fg of TabLineFill is the color.
for highlight_group in [
    \"ColorColumn", "Cursor","CursorIM", "CursorColumn", "CursorLineNr", "DiffAdd",
    \"DiffChange", "DiffDelete", "ErrorMsg", "FoldColumn", "PMenu", "PMenuThumb",
    \"Question", "Search", "TabLineSel", "TabLineFill", "Visual",
    \"VertSplit", "WarningMsg"
\]
    call s:h(highlight_group, s:reverse)
endfor

" No additional color for CursorLine, sorry.
call s:h("CursorLine", { "fg": s:none, "bg": s:none, "attrs": "underline" })
call s:h("LineNr", { "attrs": "italic" })

" Plugin highlighting groups {{{1
" TagBar {{{2
for highlight_group in ["TagBarVisibilityPublic", "TagBarVisibilityProtected", "TagBarVisibilityPrivate"]
    call s:h(highlight_group, s:normal)
endfor

" EasyMotion {{{2
call s:h("EasyMotionTarget", extend(copy(s:reverse), { "attrs": "italic,underline" }))
call s:h("EasyMotionShade", s:normal)

for highlight_group in ["GitGutterAdd", "GitGutterChange", "GitGutterDelete"]
    call s:h(highlight_group, s:normal)
endfor


" vim: foldmethod=marker foldlevel=0 sw=4
