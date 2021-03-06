local M = {}

M.gitsigns = function()
  require('gitsigns').setup {
    signs = {
      add          = { hl = "GitSignsAdd", text = "│", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
      change       = { hl = "GitSignsChange", text = "│", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
      delete       = { hl = "GitSignsDelete", text = "│", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
      topdelete    = { hl = "GitSignsDelete", text = "│", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
      changedelete = { hl = "GitSignsChange", text = "│", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
    },
  }
end

M.vimone = function()
  vim.cmd([[
    colorscheme one
    let g:one_allow_italics = 1 " I love italic for comments
    set background=dark " for the dark version
    " set background=light " for the light version
  ]])
end

M.indent_blankline = function()
  require('indent_blankline').setup {
    indentLine_enabled = 1,
    char = "▏",
    filetype_exclude = {
      "help",
      "terminal",
      "dashboard",
      "packer",
      "lspinfo",
      "TelescopePrompt",
      "TelescopeResults",
      "nvchad_cheatsheet",
      "lsp-installer",
      "",
    },
    buftype_exclude = { "terminal" },
    show_trailing_blankline_indent = false,
    show_first_indent_level = true,
    show_current_context = true,
    show_current_context_start = true,
  }
  vim.cmd([[highlight IndentBlanklineIndent1 guifg=#2C323C gui=nocombine]])
end

M.lsp_colors = function()
  require("lsp-colors").setup({
    Error = "#db4b4b",
    Warning = "#e0af68",
    Information = "#0db9d7",
    Hint = "#10B981"
  })
end

M.telescope = function()
  local set_keymap = require('utils').set_keymap
  set_keymap("n", "'t", "<cmd>Telescope<cr>")
  set_keymap("n", "'f", "<cmd>Telescope find_files<cr>")
  set_keymap("n", "'g", "<cmd>Telescope live_grep<cr>")
  set_keymap("n", "'b", "<cmd>Telescope buffers<cr>")
  set_keymap("n", "'h", "<cmd>Telescope help_tags<cr>")
  set_keymap("n", "'s", "<cmd>Telescope lsp_document_symbols<cr>")
end

M.neoclip = function()
  require('neoclip').setup {
    enable_persistent_history = true,
    continuous_sync = true,
  }
end

M.lsp_signature = function()
  local default = {
    bind = true,
    doc_lines = 0,
    floating_window = true,
    fix_pos = true,
    hint_enable = true,
    hint_prefix = " ",
    hint_scheme = "String",
    hi_parameter = "Search",
    max_height = 22,
    max_width = 120, -- max_width of signature floating_window, line will be wrapped if exceed max_width
    handler_opts = {
      border = "single", -- double, single, shadow, none
    },
    zindex = 200, -- by default it will be on top of all floating windows, set to 50 send it to bottom
    padding = "", -- character to pad on left and right of signature can be ' ', or '|'  etc
  }
  require('lsp_signature').setup(default)
end

M.refactoring = function()
  local set_keymap = require('utils').set_keymap
  local opts = { expr = false }

  require('refactoring').setup({})
  set_keymap(
    "v",
    "<leader>ff",
    "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
    opts
  )
  -- Remaps for each of the four debug operations currently offered by the plugin
  set_keymap("v", "<Leader>re", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]], opts)
  set_keymap("v", "<Leader>rf", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]], opts)
  set_keymap("v", "<Leader>rv", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]], opts)
  set_keymap("v", "<Leader>ri", [[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]], opts)
end

M.aerial = function()
  require('aerial').setup()
  require('utils').set_keymap("n", ",s", ":AerialToggle<CR>")
end

M.dap_buddy = function()
  local dap_install = require("dap-install")
  local dbg_list = require("dap-install.api.debuggers").get_installed_debuggers()

  for _, debugger in ipairs(dbg_list) do
    dap_install.config(debugger, {})
  end
end

M.neoscroll = function()
  require('neoscroll').setup()

  local t    = {}
  -- Syntax: t[keys] = {function, {function arguments}}
  t['<C-u>'] = { 'scroll', { '-vim.wo.scroll', 'true', '250' } }
  t['<C-d>'] = { 'scroll', { 'vim.wo.scroll', 'true', '250' } }
  t['<C-b>'] = { 'scroll', { '-vim.api.nvim_win_get_height(0)', 'true', '450' } }
  t['<C-f>'] = { 'scroll', { 'vim.api.nvim_win_get_height(0)', 'true', '450' } }
  t['<C-y>'] = { 'scroll', { '-0.10', 'false', '100' } }
  t['<C-e>'] = { 'scroll', { '0.10', 'false', '100' } }
  t['zt']    = { 'zt', { '250' } }
  t['zz']    = { 'zz', { '250' } }
  t['zb']    = { 'zb', { '250' } }

  require('neoscroll.config').set_mappings(t)
end

M.autosave = function()
  local autosave = require("autosave")
  autosave.setup {
    enabled = true,
    execution_message = "AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"),
    events = { "InsertLeave", "TextChanged" },
    conditions = {
      exists = true,
      filename_is_not = {},
      filetype_is_not = {},
      modifiable = true
    },
    write_all_buffers = false,
    on_off_commands = true,
    clean_command_line_interval = 0,
    debounce_delay = 135,
  }
end

M.camelCaseMotion = function()
  vim.cmd([[
    map <silent> w <Plug>CamelCaseMotion_w
    map <silent> b <Plug>CamelCaseMotion_b
    map <silent> e <Plug>CamelCaseMotion_e
    map <silent> ge <Plug>CamelCaseMotion_ge
    sunmap w
    sunmap b
    sunmap e
    sunmap ge
  ]])
end

return M
