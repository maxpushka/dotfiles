if !exists('g:loaded_lspsaga') | finish | endif

lua << EOF
local saga = require 'lspsaga'

saga.init_lsp_saga {
  error_sign = '',
  warn_sign = '',
  hint_sign = '',
  infor_sign = '',
  border_style = "round",
}

EOF

nnoremap <silent> <C-j> <Cmd>Lspsaga diagnostic_jump_next<CR>
nnoremap <silent> <C-J> <Cmd>Lspsaga diagnostic_jump_prev<CR>

nnoremap <silent>K <Cmd>Lspsaga hover_doc<CR>
inoremap <silent><C-k> <Cmd>Lspsaga signature_help<CR>

nnoremap <silent><Space>fu <Cmd>Lspsaga lsp_finder<CR>
nnoremap <silent><Space>pd <cmd>Lspsaga preview_definition<CR>
nnoremap <silent><Space>rn <Cmd>Lspsaga rename<CR>
nnoremap <silent><Space>ca <cmd>Lspsaga code_action<CR>
vnoremap <silent><Space>ca :<C-U>Lspsaga range_code_action<CR>

