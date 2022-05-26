-- Auto install packer.nvim if not exists
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  PackerBootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

local plugins = {
  -- Packer can manage itself as an optional plugin
  {
    'wbthomason/packer.nvim',
    event = "VimEnter",
  },
  { 'lewis6991/impatient.nvim' },
  { 'nathom/filetype.nvim' },
  {
    'nvim-lua/plenary.nvim',
    requires = { 'nvim-lua/popup.nvim' },
  },

  --- Git plugins ---

  {
    'tpope/vim-fugitive',
    config = function()
      require('configs.fugitive')
    end,
  },
  { 'tpope/vim-rhubarb' },

  {
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    tag = 'release', -- To the latest release
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
  },

  --- UI & Theme plugins. Look & Feel ---

  {
    'arcticicestudio/nord-vim',
    disable = true,
    config = function() vim.cmd("colorscheme nord") end,
  },
  {
    'norcalli/nvim-base16.lua',
    requires = {'norcalli/nvim.lua'},
    after = "packer.nvim",
    config = function()
      require('configs.base16')
    end,
  },

  {
    'kyazdani42/nvim-web-devicons',
    -- after = "nvim-base16.lua",
    config = function()
      require('configs.icons')
    end
  },

  {
    'norcalli/nvim-colorizer.lua',
    event = "BufRead",
    config = function()
      require('configs.colorizer')
    end,
  },

  {
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
  },
  {
    'akinsho/bufferline.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function() require('configs.bufferline') end,
  },

  {
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
  },

  {
    'folke/lsp-colors.nvim',
    config = function()
      require("lsp-colors").setup({
        Error = "#db4b4b",
        Warning = "#e0af68",
        Information = "#0db9d7",
        Hint = "#10B981"
      })
    end,
  },

  {
    'kyazdani42/nvim-tree.lua',
    requires = { 'nvim-web-devicons', opt = true }, -- optional, for file icon
    -- cmd = { 'NvimTreeOpen', 'NvimTreeToggle', 'NvimTreeFocus' },
    setup = function()
      require('utils').set_keymap("n", ",e", "<Cmd>NvimTreeToggle<CR>")
    end,
    config = function() require('configs.nvimtree') end,
  },

  {
    'nvim-telescope/telescope.nvim',
    requires = 'nvim-lua/plenary.nvim',
    module = "telescope",
    cmd = "Telescope",
    setup = function()
      local set_keymap = require('utils').set_keymap
      set_keymap('n', ';f',  '<cmd>Telescope find_files<cr>')
      set_keymap('n', ';g',  '<cmd>Telescope live_grep<cr>')
      set_keymap('n', ';b',  '<cmd>Telescope buffers<cr>')
      set_keymap('n', ';h',  '<cmd>Telescope help_tags<cr>')
    end,
    config = function() require('configs.telescope') end
  },
  {
    {
      'nvim-telescope/telescope-project.nvim',
      setup = function()
        require('utils').set_keymap('n', ';p',  '<cmd>Telescope project<cr>')
      end,
    },
    {
      'nvim-telescope/telescope-file-browser.nvim',
      setup = function()
        require('utils').set_keymap('n', ';e',  '<cmd>Telescope file_browser<cr>')
      end,
    },
    {
      "AckslD/nvim-neoclip.lua",
      requires = {'tami5/sqlite.lua', module = 'sqlite'},
      setup = function()
        require('utils').set_keymap('n', ';y',  '<cmd>Telescope neoclip<cr>')
      end,
      disable = true,
    },
    {
      'ThePrimeagen/git-worktree.nvim',
      setup = function()
        local set_keymap = require('utils').set_keymap
        set_keymap('n', ';wl', '<cmd>Telescope git_worktree git_worktrees<cr>')
        set_keymap('n', ';wc', '<cmd>Telescope git_worktree create_git_worktree<cr>')
      end,
    },
    requires = 'nvim-telescope/telescope.nvim',
  },

  {
    "folke/twilight.nvim",
    cmd = {"Twilight", "TwilightEnable", "TwilightDisable"},
    setup = function()
      require('utils').set_keymap("n", "<space>t", "<Cmd>Twilight<CR>")
    end,
    config = function() require("twilight") end,
  },

  {
    'tami5/lspsaga.nvim',
    require = 'neovim/nvim-lspconfig',
    config = function() require('lspsaga').setup() end,
  },

  --- LSP stuff ---

  {
    'neovim/nvim-lspconfig',
    config = function() require('configs.lspconfig') end,
  },
  {
    'onsails/lspkind-nvim',
    config = function() require('lspkind').init() end,
  },
  {
    'williamboman/nvim-lsp-installer',
    requires = 'neovim/nvim-lspconfig',
  },

  {
    'hrsh7th/nvim-cmp',
    requires = {
      'neovim/nvim-lspconfig',
      'onsails/lspkind-nvim',
    },
  },
  {
    "hrsh7th/cmp-nvim-lsp", 'hrsh7th/cmp-nvim-lua',
    "hrsh7th/cmp-buffer", 'hrsh7th/cmp-path',
    'hrsh7th/cmp-calc', 'hrsh7th/cmp-emoji',
    'f3fora/cmp-spell', 'octaltree/cmp-look',
    'saadparwaiz1/cmp_luasnip', -- Snippets source for nvim-cmp
    'L3MON4D3/LuaSnip', -- Snippets plugin
    requires = 'hrsh7th/nvim-cmp',
  },
  {
    'tzachar/cmp-tabnine',
    run = './install.sh',
    requires = 'hrsh7th/nvim-cmp',
  },
  {
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
  },

  { -- syntax parsers and highlighters
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function() require('configs.treesitter') end,
  },
  { -- tresitter plugins
    'windwp/nvim-ts-autotag',
    'p00f/nvim-ts-rainbow',
    'romgrk/nvim-treesitter-context',
    {
      'nvim-treesitter/playground',
      cmd = 'TSPlaygroundToggle',
      setup = function()
        require('utils').set_keymap('n', '<F8>', ":TSPlaygroundToggle<CR>")
      end,
    },
    {
      "ThePrimeagen/refactoring.nvim",
      requires = {
        {"nvim-lua/plenary.nvim"},
        {"nvim-treesitter/nvim-treesitter"}
      },
      config = function()
        local set_keymap = require('utils').set_keymap
        local opts = {expr = false}

        require('refactoring').setup({})
        set_keymap(
          "v",
          "<leader>ff",
          "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
          opts
        )
        -- Remaps for each of the four debug operations currently offered by the plugin
        set_keymap("v", "<Leader>re", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]],         opts)
        set_keymap("v", "<Leader>rf", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]], opts)
        set_keymap("v", "<Leader>rv", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]],         opts)
        set_keymap("v", "<Leader>ri", [[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],          opts)
      end,
    },
    requires = 'nvim-treesitter/nvim-treesitter',
    event = "BufRead",
  },

  {
    'simrat39/symbols-outline.nvim',
    requires = {
      {'kyazdani42/nvim-web-devicons', opt = true}, -- for file icons
    },
    config = function()
      require('configs.symbols-outline')
      require('utils').set_keymap("n", ",s", ":SymbolsOutline<CR>")
    end,
  },

  {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    setup = function()
      local set_keymap = require('utils').set_keymap
      local opts = { silent = false }
      set_keymap("n", "<leader>xx", "<Cmd>Trouble<CR>", opts)
      set_keymap("n", "<leader>xw", "<Cmd>Trouble workspace_diagnostics<CR>", opts)
      set_keymap("n", "<leader>xd", "<Cmd>Trouble document_diagnostics<CR>", opts)
      set_keymap("n", "<leader>xl", "<Cmd>Trouble loclist<CR>", opts)
      set_keymap("n", "<leader>xq", "<Cmd>Trouble quickfix<CR>", opts)
      set_keymap("n", "gR", "<Cmd>Trouble lsp_references<CR>", opts)
    end,
    cmd = "Trouble",
    config = function()
      require("trouble").setup{}
    end,
  },

  --- DAP plugins ---

  {
    'mfussenegger/nvim-dap',
    module = "dap",
    setup = function()
      local set_keymap = require('utils').set_keymap
      set_keymap('n', '<leader>dc', '<cmd>lua require"dap".continue()<CR>')
      set_keymap('n', '<leader>dv', '<cmd>lua require"dap".step_over()<CR>')
      set_keymap('n', '<leader>di', '<cmd>lua require"dap".step_into()<CR>')
      set_keymap('n', '<leader>do', '<cmd>lua require"dap".step_out()<CR>')
      set_keymap('n', '<leader>db', '<cmd>lua require"dap".toggle_breakpoint()<CR>')
    end
  },

  {
    "Pocco81/dap-buddy.nvim",
    branch = "dev",
    requires = 'mfussenegger/nvim-dap',
    after = 'nvim-dap',
    config = function()
      local dap_install = require("dap-install")
      local dbg_list = require("dap-install.api.debuggers").get_installed_debuggers()

      for _, debugger in ipairs(dbg_list) do
        dap_install.config(debugger, {})
      end
    end,
  },

  {
    'theHamsta/nvim-dap-virtual-text',
    requires = {
      'mfussenegger/nvim-dap',
      'nvim-treesitter/nvim-treesitter',
    },
    after = 'nvim-dap',
    config = function()
      require("nvim-dap-virtual-text").setup{}
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    requires = { "mfussenegger/nvim-dap" },
    setup = function()
      require('utils').set_keymap("n", ",d", "<cmd>lua require('dapui').toggle()<CR>")
    end,
    after = 'nvim-dap',
    config = function()
      require("dapui").setup()
    end,
  },

  {
    "rcarriga/vim-ultest",
    requires = "vim-test/vim-test",
    run = ":UpdateRemotePlugins",
    setup = function()
      local set_keymap = require('utils').set_keymap
      set_keymap("n", ",t",           "<Cmd>UltestSummary<CR>",     {noremap = true})
      set_keymap("n", "<leader>uo",  "<Cmd>UltestOutput<CR>",       {noremap = true})

      set_keymap("n", "<leader>ur",  "<Cmd>Ultest<CR>",             {noremap = true})
      set_keymap("n", "<leader>urn", "<Cmd>UltestNearest<CR>",      {noremap = true})

      set_keymap("n", "<leader>ud",  "<Cmd>UltestDebug<CR>",        {noremap = true})
      set_keymap("n", "<leader>udn", "<Cmd>UltestDebugNearest<CR>", {noremap = true})
    end,
    cmd = {
      "UltestSummary", "UltestOutput",
      "Ultest", "UltestNearest",
      "UltestDebug", "UltestDebugNearest" },
    config = function()
      require('configs.ultest').post()
    end,
  },

  --- Miscellaneous ---

  {
    'famiu/bufdelete.nvim',
    cmd = "Bdelete",
    setup = function()
      require('utils').set_keymap('n', '<leader>bd', ":Bdelete<CR>")
    end,
  },

  {
    'numToStr/Comment.nvim',
    config = function() require('Comment').setup() end,
  },

  { 'tpope/vim-surround' },

  {
    'windwp/nvim-autopairs',
    after = 'nvim-cmp',
    config = function() require('configs.autopairs') end,
  },

  {
    "max397574/better-escape.nvim",
    event = "InsertCharPre",
    config = function() require("better_escape").setup() end,
  },

  {
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
  },

  {
    "luukvbaal/stabilize.nvim",
    config = function() require("stabilize").setup() end
  },

  {
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
  },

  {
    "Pocco81/TrueZen.nvim",
    cmd = { "TZAtaraxis", "TZFocus", "TZMinimalist" },
  },

  {
    'glepnir/dashboard-nvim',
    setup = function()
      local set_keymap = require('utils').set_keymap
      set_keymap("n", "<leader>sn", "<Cmd>DashboardNewFile<CR>") -- basically create a new buffer
    end,
    config = function() require('configs.dashboard') end,
  },

  {
    'windwp/nvim-spectre',
    requires = 'nvim-lua/plenary.nvim',
    module = 'spectre',
    setup = function()
      local set_keymap = require('utils').set_keymap

      set_keymap("n", "<leader>S", "<cmd>lua require('spectre').open()<CR>")
      -- search current word
      set_keymap("n", "<leader>sw", "<cmd>lua require('spectre').open_visual({select_word=true})<CR>")
      set_keymap("v", "<leader>s", "<cmd>lua require('spectre').open_visual()<CR>")
      -- search in current file
      set_keymap("n", "<leader>sp", "viw<cmd>lua require('spectre').open_file_search()<CR>")
    end,
    config = function()
      require('spectre').setup()
    end,
  },

  {
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
  },
  { 'ggandor/lightspeed.nvim' },

  {
    "rafaelsq/nvim-goc.lua",
    config = function ()
      require('configs.goc')
    end
  }
}


return require('packer').startup(function(use)
  for _, v in pairs(plugins) do
    use(v)
  end

  if PackerBootstrap then
    require('packer').sync()
  end
end)
