let g:airline#themes#taxicab#palette = {}

let s:normal = [ '#ffcd00', '#000000', '220', '16' ]
let s:reverse = [ '#000000', '#ffcd00', '16', '220' ]

let g:airline#themes#taxicab#palette.normal = airline#themes#generate_color_map(s:normal, s:reverse, s:reverse)

let g:airline#themes#taxicab#palette.normal.airline_warning = s:reverse

" From dark_minimal
let pal = g:airline#themes#taxicab#palette
for item in ['insert', 'replace', 'visual', 'inactive', 'ctrlp']
  exe "let pal.".item." = pal.normal"
  for suffix in ['_modified', '_paste']
    exe "let pal.".item.suffix. " = pal.normal"
  endfor
endfor
