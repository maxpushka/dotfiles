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
  use { 'lewis6991/impatient.nvim' }
  use { 'nathom/filetype.nvim' }
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
  use { 'tpope/vim-rhubarb' }

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
    'norcalli/nvim-base16.lua',
    requires = {'norcalli/nvim.lua'},
    after = "packer.nvim",
    config = function()
      base16 = require('base16')
      base16(base16.themes["gruvbox-dark-soft"], true)
    end,
  }

  use {
    'kyazdani42/nvim-web-devicons',
    after = "nvim-base16.lua",
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
      "SmiteshP/nvim-gps",
    },
    config = function() require('configs.lualine') end,
  }
  use {
    "SmiteshP/nvim-gps",
    requires = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-gps").setup()
      -- set up is configs.lualine
    end,
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
      }
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
    cmd = { "NvimTreeOpen", "NvimTreeToggle", "NvimTreeFocus" },
    config = function() require('configs.nvimtree') end,
    setup = function()
      vim.api.nvim_set_keymap("n", ",e", ":NvimTreeToggle<CR>", {noremap = true, silent = true})
    end,
  }

  use {
    'nvim-telescope/telescope.nvim',
    requires = 'nvim-lua/plenary.nvim',
    module = "telescope",
    cmd = "Telescope",
    setup = function()
      local function set_keymap(...) vim.api.nvim_set_keymap(...) end
      local opts = { noremap=true, silent=true }

      set_keymap('n', ';f', '<cmd>Telescope find_files<cr>', opts)
      set_keymap('n', ';e', '<cmd>Telescope file_browser<cr>', opts)
      set_keymap('n', ';g', '<cmd>Telescope live_grep<cr>', opts)
      set_keymap('n', ';b', '<cmd>Telescope buffers<cr>', opts)
      set_keymap('n', ';h', '<cmd>Telescope help_tags<cr>', opts)
      set_keymap('n', ';p', '<cmd>Telescope project<cr>', opts)
      set_keymap('n', ';y', '<cmd>Telescope neoclip<cr>', opts)
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
        require('neoclip').setup{ enable_persistant_history = true } 
      end,
    },
    requires = 'nvim-telescope/telescope.nvim',
  }

  use {
    "folke/twilight.nvim",
    config = function() require("twilight") end,
  }

  --- LSP stuff ---
  use {
    'neovim/nvim-lspconfig',
    config = function() require('configs.lspconfig') end,
    module = "lspconfig",
    opt = true,
  }

  use {
    'hrsh7th/nvim-cmp',
    requires = { 'onsails/lspkind-nvim' },
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
    'williamboman/nvim-lsp-installer',
    requires = 'neovim/nvim-lspconfig',
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
    requires = 'nvim-treesitter/nvim-treesitter',
    event = "BufRead",
  }

  use {
    'simrat39/symbols-outline.nvim',
    cmd = "SymbolsOutline",
    setup = function()
      vim.api.nvim_set_keymap("n", ",s", ":SymbolsOutline<CR>", {noremap = true})
      vim.api.nvim_set_keymap("i", ",s", ":SymbolsOutline<CR>", {noremap = true})
      vim.api.nvim_set_keymap("v", ",s", ":SymbolsOutline<CR>", {noremap = true})
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

      vim.api.nvim_set_keymap("n", "<leader>xx", "<cmd>Trouble<cr>",
        {silent = true, noremap = true}
      )
      vim.api.nvim_set_keymap("n", "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>",
        {silent = true, noremap = true}
      )
      vim.api.nvim_set_keymap("n", "<leader>xd", "<cmd>Trouble document_diagnostics<cr>",
        {silent = true, noremap = true}
      )
      vim.api.nvim_set_keymap("n", "<leader>xl", "<cmd>Trouble loclist<cr>",
        {silent = true, noremap = true}
      )
      vim.api.nvim_set_keymap("n", "<leader>xq", "<cmd>Trouble quickfix<cr>",
        {silent = true, noremap = true}
      )
      vim.api.nvim_set_keymap("n", "gR", "<cmd>Trouble lsp_references<cr>",
        {silent = true, noremap = true}
      )
    end,
  }

  --- Miscellaneous ---

  use {
    'famiu/bufdelete.nvim',
    config = function ()
      vim.api.nvim_set_keymap('n', 'sd', ":Bdelete<CR>", {noremap=true})
    end,
  }

  use {
    'numToStr/Comment.nvim',
    config = function()
        require('Comment').setup()
    end
  }

  use { 'tpope/vim-surround' }

  
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

  if PackerBootstrap then
    require('packer').sync()
  end
end}
