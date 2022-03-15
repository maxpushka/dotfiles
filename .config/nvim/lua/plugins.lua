-- Auto install packer.nvim if not exists
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  PackerBootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require('packer').startup{function(use)
  -- Packer can manage itself as an optional plugin
  use {
    'wbthomason/packer.nvim',
    event = "VimEnter",
  }
  use 'lewis6991/impatient.nvim'
  use 'nathom/filetype.nvim'
  use {
    'nvim-lua/plenary.nvim',
    requires = { 'nvim-lua/popup.nvim' }
  }

  --- Git plugins ---
  use {
    'tpope/vim-fugitive',
    config = function()
      require('configs.fugitive')
    end
  }
  use 'tpope/vim-rhubarb'

  use {
    -- TODO: lazyload like in NvChad
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    tag = 'release', -- To use the latest release
    config = function()
      require('gitsigns').setup{
        signs = {
          add          = { hl = "GitSignsAdd"   , text = "│", numhl = "GitSignsAddNr"   , linehl = "GitSignsAddLn" },
          change       = { hl = "GitSignsChange", text = "│", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
          delete       = { hl = "GitSignsDelete", text = "│", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
          topdelete    = { hl = "GitSignsDelete", text = "│", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
          changedelete = { hl = "GitSignsChange", text = "│", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
        },
      }
    end,
  }

  --- UI & Theme plugins. Look & Feel ---
  use {
    'arcticicestudio/nord-vim',
    disable = true,
    config = function() vim.cmd("colorscheme nord") end,
  }
  use {
    'norcalli/nvim-base16.lua',
    requires = {'norcalli/nvim.lua'},
    after = "packer.nvim",
    config = function()
      local base16 = require('base16')
      base16(base16.themes["gruvbox-dark-hard"], true)
    end,
  }

  use {
    'kyazdani42/nvim-web-devicons',
    -- after = "nvim-base16.lua",
    config = function()
      require('configs.icons')
    end
  }

  use {
    'norcalli/nvim-colorizer.lua',
    event = "BufRead",
    config = function()
      require('configs.colorizer')
    end,
  }

  use {
    'nvim-lualine/lualine.nvim',
    requires = {
      { 'kyazdani42/nvim-web-devicons', opt = true },
      {
        "SmiteshP/nvim-gps",
        requires = "nvim-treesitter/nvim-treesitter",
      }
    },
    after = "nvim-gps",
    config = function() require('configs.lualine') end,
  }
  use {
    'akinsho/bufferline.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function() require('configs.bufferline') end,
  }

  use {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufRead",
    config = function()
      require('indent_blankline').setup{
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
  }

  use {
    'folke/lsp-colors.nvim',
    config = function()
      require("lsp-colors").setup({
        Error = "#db4b4b",
        Warning = "#e0af68",
        Information = "#0db9d7",
        Hint = "#10B981"
      })
    end,
  }

  use {
    'kyazdani42/nvim-tree.lua',
    requires = { 'nvim-web-devicons', opt = true }, -- optional, for file icon
    cmd = { 'NvimTreeOpen', 'NvimTreeToggle', 'NvimTreeFocus' },
    setup = function()
      vim.api.nvim_set_keymap("n", ",e", "<Cmd>NvimTreeToggle<CR>", {noremap = true, silent = true})
    end,
    config = function() require('configs.nvimtree') end,
  }

  use {
    'nvim-telescope/telescope.nvim',
    requires = 'nvim-lua/plenary.nvim',
    module = "telescope",
    cmd = "Telescope",
    setup = function()
      local function map(...) vim.api.nvim_set_keymap(...) end
      local opts = { noremap=true, silent=true }

      map('n', ';f',  '<cmd>Telescope find_files<cr>', opts)
      map('n', ';e',  '<cmd>Telescope file_browser<cr>', opts)
      map('n', ';g',  '<cmd>Telescope live_grep<cr>', opts)
      map('n', ';b',  '<cmd>Telescope buffers<cr>', opts)
      map('n', ';h',  '<cmd>Telescope help_tags<cr>', opts)
      map('n', ';p',  '<cmd>Telescope project<cr>', opts)
      map('n', ';y',  '<cmd>Telescope neoclip<cr>', opts)
      map('n', ';wl', '<cmd>Telescope git_worktree git_worktrees<cr>', opts)
      map('n', ';wc', '<cmd>Telescope git_worktree create_git_worktree<cr>', opts)
    end,
    config = function() require('configs.telescope') end
  }
  use {
    'nvim-telescope/telescope-project.nvim',
    'nvim-telescope/telescope-file-browser.nvim',
    {
      "AckslD/nvim-neoclip.lua",
      requires = {'tami5/sqlite.lua', module = 'sqlite'},
      config = function()
        require('neoclip').setup{ enable_persistent_history = true }
      end,
    },
    'ThePrimeagen/git-worktree.nvim',
    requires = 'nvim-telescope/telescope.nvim',
  }

  use {
    "folke/twilight.nvim",
    cmd = {"Twilight", "TwilightEnable", "TwilightDisable"},
    setup = function ()
      vim.api.nvim_set_keymap("n", "<space>t", "<Cmd>Twilight<CR>", {noremap = true, silent = true})
    end,
    config = function() require("twilight") end,
  }

  --- LSP stuff ---
  use {
    'neovim/nvim-lspconfig',
    config = function() require('configs.lspconfig') end,
  }

  use {
    'hrsh7th/nvim-cmp',
    requires = { 'onsails/lspkind-nvim' },
  }
  use {
    'williamboman/nvim-lsp-installer',
    requires = 'neovim/nvim-lspconfig',
  }
  use {
    "hrsh7th/cmp-nvim-lsp", 'hrsh7th/cmp-nvim-lua',
    "hrsh7th/cmp-buffer", 'hrsh7th/cmp-path',
    'hrsh7th/cmp-calc', 'hrsh7th/cmp-emoji',
    'f3fora/cmp-spell', 'octaltree/cmp-look',
    'saadparwaiz1/cmp_luasnip', -- Snippets source for nvim-cmp
    'L3MON4D3/LuaSnip', -- Snippets plugin
    requires = 'hrsh7th/nvim-cmp',
  }
  use {
    'tzachar/cmp-tabnine',
    run = './install.sh',
    requires = 'hrsh7th/nvim-cmp',
  }
  use {
    "ray-x/lsp_signature.nvim",
    after = "nvim-lspconfig",
    config = function()
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
    end,
  }

  use { -- syntax parsers and highlighters
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function() require('configs.treesitter') end,
  }
  use { -- tresitter plugins
    'windwp/nvim-ts-autotag',
    'p00f/nvim-ts-rainbow',
    'romgrk/nvim-treesitter-context',
    {
      'nvim-treesitter/playground',
      cmd = 'TSPlaygroundToggle',
      setup = function()
        vim.api.nvim_set_keymap('n', '<F8>', ":TSPlaygroundToggle<CR>", {noremap=true})
      end,
    },
    {
      "ThePrimeagen/refactoring.nvim",
      requires = {
        {"nvim-lua/plenary.nvim"},
        {"nvim-treesitter/nvim-treesitter"}
      },
      config = function ()
        local function map(...) vim.api.nvim_set_keymap(...) end
        local opts = {noremap = true, silent = true, expr = false}

        require('refactoring').setup({})
        vim.api.nvim_set_keymap(
          "v",
          "<leader>ff",
          "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
          opts
        )
        -- Remaps for each of the four debug operations currently offered by the plugin
        map("v", "<Leader>re", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]],         opts)
        map("v", "<Leader>rf", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]], opts)
        map("v", "<Leader>rv", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]],         opts)
        map("v", "<Leader>ri", [[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],          opts)
      end,
    },
    requires = 'nvim-treesitter/nvim-treesitter',
    event = "BufRead",
  }

  use {
    'simrat39/symbols-outline.nvim',
    cmd = "SymbolsOutline",
    setup = function()
      vim.api.nvim_set_keymap("n", ",s", ":SymbolsOutline<CR>", {noremap = true})
    end,
    config = function() require('configs.symbols-outline') end,
    requires = {
      {'kyazdani42/nvim-web-devicons', opt = true}, -- for file icons
    },
  }

  use {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup{}

      local function map(...) vim.api.nvim_set_keymap(...) end
      local opts = {noremap = true, silent = true}
      map("n", "<leader>xx", "<cmd>Trouble<cr>", opts)
      map("n", "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>", opts)
      map("n", "<leader>xd", "<cmd>Trouble document_diagnostics<cr>", opts)
      map("n", "<leader>xl", "<cmd>Trouble loclist<cr>", opts)
      map("n", "<leader>xq", "<cmd>Trouble quickfix<cr>", opts)
      map("n", "gR", "<cmd>Trouble lsp_references<cr>", opts)
    end,
  }

  use {
    'rmagatti/goto-preview',
    config = function()
      require('goto-preview').setup {}
    end
  }

  --- DAP plugins ---

  use {
    'mfussenegger/nvim-dap',
    module = "dap",
    setup = function ()
      local utils = require('utils')
      utils.map('n', '<leader>dc', '<cmd>lua require"dap".continue()<CR>')
      utils.map('n', '<leader>dsv', '<cmd>lua require"dap".step_over()<CR>')
      utils.map('n', '<leader>dsi', '<cmd>lua require"dap".step_into()<CR>')
      utils.map('n', '<leader>dso', '<cmd>lua require"dap".step_out()<CR>')
      utils.map('n', '<leader>dt', '<cmd>lua require"dap".toggle_breakpoint()<CR>')
    end
  }

  use {
    "Pocco81/DAPInstall.nvim",
    requires = 'mfussenegger/nvim-dap',
    after = 'nvim-dap',
    config = function ()
      local dap_install = require("dap-install")
      local dbg_list = require("dap-install.api.debuggers").get_installed_debuggers()

      for _, debugger in ipairs(dbg_list) do
        dap_install.config(debugger, {})
      end
    end,
  }

  use {
    'theHamsta/nvim-dap-virtual-text',
    requires = {
      'mfussenegger/nvim-dap',
      'nvim-treesitter/nvim-treesitter',
    },
    after = 'nvim-dap',
    config = function ()
      require("nvim-dap-virtual-text").setup{}
    end,
  }

  use {
    "rcarriga/nvim-dap-ui",
    requires = { "mfussenegger/nvim-dap" },
    setup = function()
      local function map(...) vim.api.nvim_set_keymap(...) end
      local opts = {noremap = true, silent = true}
      map("n", ",d", "<cmd>lua require('dapui').toggle()<CR>", opts)
    end,
    after = 'nvim-dap',
    config = function ()
      require("dapui").setup()
    end,
  }

  use {
    "rcarriga/vim-ultest",
    requires = {"vim-test/vim-test"},
    run = "<Cmd>UpdateRemotePlugins",
    setup = function()
      vim.api.nvim_set_keymap("n", ",t", "<Cmd>UltestSummary<CR>", {noremap = true})
    end,
    cmd = { "Ultest", "UltestSummary", "UltestDebugNearest" },
    config = "require('configs.ultest').post()",
  }

  --- Miscellaneous ---

  use {
    'famiu/bufdelete.nvim',
    config = function ()
      vim.api.nvim_set_keymap('n', '<leader>sd', ":Bdelete<CR>", {noremap=true})
    end,
  }

  use {
    'numToStr/Comment.nvim',
    config = function()
        require('Comment').setup()
    end,
  }

  use 'tpope/vim-surround'

  use {
    'windwp/nvim-autopairs',
    after = 'nvim-cmp',
    config = function() require('configs.autopairs') end,
  }

  use {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function() require("better_escape").setup() end,
  }

  use {
    "karb94/neoscroll.nvim",
    config = function()
      require('neoscroll').setup()

      local t = {}
      -- Syntax: t[keys] = {function, {function arguments}}
      t['<C-u>'] = {'scroll', {'-vim.wo.scroll', 'true', '250'}}
      t['<C-d>'] = {'scroll', { 'vim.wo.scroll', 'true', '250'}}
      t['<C-b>'] = {'scroll', {'-vim.api.nvim_win_get_height(0)', 'true', '450'}}
      t['<C-f>'] = {'scroll', { 'vim.api.nvim_win_get_height(0)', 'true', '450'}}
      t['<C-y>'] = {'scroll', {'-0.10', 'false', '100'}}
      t['<C-e>'] = {'scroll', { '0.10', 'false', '100'}}
      t['zt']    = {'zt', {'250'}}
      t['zz']    = {'zz', {'250'}}
      t['zb']    = {'zb', {'250'}}

      require('neoscroll.config').set_mappings(t)
    end,
  }

  use {
    "luukvbaal/stabilize.nvim",
    config = function() require("stabilize").setup() end
  }

  use {
    "Pocco81/AutoSave.nvim",
    config = function()
      local autosave = require("autosave")
        autosave.setup{
          enabled = true,
          execution_message = "AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"),
          events = {"InsertLeave", "TextChanged"},
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
    end,
  }

  use "Pocco81/TrueZen.nvim"

  use {
    'glepnir/dashboard-nvim',
    setup = function()
      vim.api.nvim_set_keymap("n", "<leader>bm", "<Cmd>DashboardJumpMarks<CR>", {})
      vim.api.nvim_set_keymap("n", "<leader>fn", "<Cmd>DashboardNewFile<CR>",   {}) -- basically create a new buffer
      vim.api.nvim_set_keymap("n", "<leader>db", "<Cmd>Dashboard<CR>",          {}) -- open dashboard
      -- vim.api.nvim_set_keymap("n", "<leader>l",  "<Cmd>SessionLoad<CR>",        {})
      -- vim.api.nvim_set_keymap("n", "<leader>s",  "<Cmd>SessionSave<CR>",        {})
    end,
    config = function() require('configs.dashboard') end,
  }

  use {
    'windwp/nvim-spectre',
    requires = 'nvim-lua/plenary.nvim',
    module = 'spectre',
    setup = function ()
      local function map(...) vim.api.nvim_set_keymap(...) end
      local opts = { noremap=true }
      map("n", "<leader>S", "<cmd>lua require('spectre').open()<CR>", opts)

      -- search current word
      map("n", "<leader>sw", "<cmd>lua require('spectre').open_visual({select_word=true})<CR>", opts)
      map("v", "<leader>s", "<cmd>lua require('spectre').open_visual()<CR>", opts)
      -- search in current file
      map("n", "<leader>sp", "viw<cmd>lua require('spectre').open_file_search()<CR>", opts)
    end,
    config = function()
      require('spectre').setup()
    end,
  }

  use {
    'bkad/CamelCaseMotion',
    config = function()
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
    end,
  }
  use {
    'easymotion/vim-easymotion',
    disable = true,
    config = function ()
      vim.g.EasyMotion_smartcase = 1
    end
  }
  use {
    'ggandor/lightspeed.nvim',
    keys = {
      '<Plug>Lightspeed_s',
      '<Plug>Lightspeed_S',
      '<Plug>Lightspeed_x',
      '<Plug>Lightspeed_X',
      '<Plug>Lightspeed_f',
      '<Plug>Lightspeed_F',
      '<Plug>Lightspeed_t',
      '<Plug>Lightspeed_T',
    },
    setup = function()
      local default_keymaps = {
        { 'n', 's', '<Plug>Lightspeed_s' },
        { 'n', 'S', '<Plug>Lightspeed_S' },
        { 'x', 's', '<Plug>Lightspeed_s' },
        { 'x', 'S', '<Plug>Lightspeed_S' },
        { 'o', 'z', '<Plug>Lightspeed_s' },
        { 'o', 'Z', '<Plug>Lightspeed_S' },
        { 'o', 'x', '<Plug>Lightspeed_x' },
        { 'o', 'X', '<Plug>Lightspeed_X' },
        { 'n', 'f', '<Plug>Lightspeed_f' },
        { 'n', 'F', '<Plug>Lightspeed_F' },
        { 'x', 'f', '<Plug>Lightspeed_f' },
        { 'x', 'F', '<Plug>Lightspeed_F' },
        { 'o', 'f', '<Plug>Lightspeed_f' },
        { 'o', 'F', '<Plug>Lightspeed_F' },
        { 'n', 't', '<Plug>Lightspeed_t' },
        { 'n', 'T', '<Plug>Lightspeed_T' },
        { 'x', 't', '<Plug>Lightspeed_t' },
        { 'x', 'T', '<Plug>Lightspeed_T' },
        { 'o', 't', '<Plug>Lightspeed_t' },
        { 'o', 'T', '<Plug>Lightspeed_T' },
      }
      for _, m in ipairs(default_keymaps) do
        vim.api.nvim_set_keymap(m[1], m[2], m[3], { silent = true })
      end
    end,
  }

  if PackerBootstrap then
    require('packer').sync()
  end
end}
