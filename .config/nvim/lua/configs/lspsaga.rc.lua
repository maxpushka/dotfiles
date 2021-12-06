local status, saga = pcall(require, 'lspsaga')
if (not status) then return end

saga.init_lsp_saga {
  error_sign = '',
  warn_sign = '',
  hint_sign = '',
  infor_sign = '',
  border_style = "round",
}

-- Mappings.
local function set_keymap(...) vim.api.nvim_set_keymap(bufnr, ...) end
local opts = { noremap=true, silent=true }

set_keymap('n', '<C-j>', '<Cmd>Lspsaga diagnostic_jump_next<CR>', opts)
set_keymap('n', '<C-J>', '<Cmd>Lspsaga diagnostic_jump_prev<CR>', opts)

set_keymap('n', 'K', '<Cmd>Lspsaga hover_doc<CR>', opts)
set_keymap('i', '<C-k>', '<Cmd>Lspsaga signature_help<CR>', opts)

set_keymap('n', '<Space>gr', '<Cmd>Lspsaga lsp_finder<CR>', opts)
set_keymap('n', '<Space>pd', '<cmd>Lspsaga preview_definition<CR>', opts)
set_keymap('n', '<Space>rn', '<Cmd>Lspsaga rename<CR>', opts)
set_keymap('n', '<Space>ca', '<cmd>Lspsaga code_action<CR>', opts)
set_keymap('v', '<Space>ca', ':<C-U>Lspsaga range_code_action<CR>', opts)
