let g:airline#themes#taxicab#palette = {}
" RIP ctermfgbg
let s:a = [ '#ffdf41', '#000000', '', '' ]
let s:b = [ '#000000', '#ffdf41', '', '' ]
let g:airline#themes#taxicab#palette.normal = airline#themes#generate_color_map(s:a, s:b, s:b)

let g:airline#themes#taxicab#palette.normal.airline_warning = s:b

let pal = g:airline#themes#taxicab#palette
for item in ['insert', 'replace', 'visual', 'inactive', 'ctrlp']
  " why doesn't this work?
  " get E713: cannot use empty key for dictionary
  "let pal.{item} = pal.normal
  exe "let pal.".item." = pal.normal"
  for suffix in ['_modified', '_paste']
    exe "let pal.".item.suffix. " = pal.normal"
  endfor
endfor
