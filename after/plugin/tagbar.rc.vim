nmap <silent><F8> <cmd>TagbarToggle<CR>

let g:tagbar_type_javascript = {
      \ 'ctagstype': 'javascript',
      \ 'kinds': [
      \ 'a:arrays',
      \ 'p:properties',
      \ 't:tags',
      \ 'o:objects',
      \ 'g:generator functions',
      \ 'f:functions',
      \ 'c:constructors/classes',
      \ 'm:methods',
      \ 'v:variables',
      \ 'i:imports',
      \ 'e:exports',
      \ 's:styled components'
      \ ]}

let g:tagbar_type_json = {
    \ 'ctagstype' : 'json',
    \ 'kinds' : [
      \ 'o:objects',
      \ 'a:arrays',
      \ 'n:numbers',
      \ 's:strings',
      \ 'b:booleans',
      \ 'z:nulls'
    \ ],
  \ 'sro' : '.',
    \ 'scope2kind': {
    \ 'object': 'o',
      \ 'array': 'a',
      \ 'number': 'n',
      \ 'string': 's',
      \ 'boolean': 'b',
      \ 'null': 'z'
    \ },
    \ 'kind2scope': {
    \ 'o': 'object',
      \ 'a': 'array',
      \ 'n': 'number',
      \ 's': 'string',
      \ 'b': 'boolean',
      \ 'z': 'null'
    \ },
    \ 'sort' : 0
    \ }

