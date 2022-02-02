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
  -- use { 'nathom/filetype.nvim' }
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

  --- UI & Theme plugins ---
  use {
    'arcticicestudio/nord-vim',
    config = function()
      vim.cmd("colorscheme nord")
    end
  }

  use {
    'norcalli/nvim-base16.lua',
    requires = {'norcalli/nvim.lua'},
    after = "packer.nvim",
    -- config = function()
    --   base16 = require('base16')
    --   base16(base16.themes["material-darker"], true)
    -- end,
  }

  use {
    'kyazdani42/nvim-web-devicons',
    after = "nvim-base16.lua",
    config = function()
      require('configs.icons')
    end
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
    'norcalli/nvim-colorizer.lua',
    event = "BufRead",
    config = function()
      require('configs.colorizer')
    end
  }

  use {
    'nvim-lualine/lualine.nvim',
    requires = {
      'kyazdani42/nvim-web-devicons', opt = true
    },
    config = function() require('configs.lualine') end
  }
  use {
    'kdheepak/tabline.nvim',
    config = function() require('configs.tabline') end,
    requires = {
      { 'hoob3rt/lualine.nvim', opt = true },
      { 'kyazdani42/nvim-web-devicons', opt = true }
    }
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
    end
  }

  --- LSP stuff ---
  use {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  }

  use { 'onsails/lspkind-nvim' }
  use { 'hrsh7th/nvim-cmp' }
  use {
    "hrsh7th/cmp-nvim-lsp", 'hrsh7th/cmp-nvim-lua',
    "hrsh7th/cmp-buffer", 'hrsh7th/cmp-path',
    'hrsh7th/cmp-calc', 'hrsh7th/cmp-emoji',
    'f3fora/cmp-spell', 'octaltree/cmp-look',
    'saadparwaiz1/cmp_luasnip', -- Snippets source for nvim-cmp
    'L3MON4D3/LuaSnip', -- Snippets plugin
    after = 'hrsh7th/nvim-cmp',
  }
  use {
    'tzachar/cmp-tabnine',
    run = './install.sh',
    requires = 'hrsh7th/nvim-cmp'
  }
  use {
    'williamboman/nvim-lsp-installer',
    requires = 'neovim/nvim-lspconfig',
    config = function() require('configs.lspconfig') end,
  }

  -- syntax parsers and highlighters
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    -- event = "BufRead",
    config = function()
      require('configs.treesitter')
    end,
  }
  use {
    'nvim-treesitter/playground',
    requires = {
      'nvim-treesitter/nvim-treesitter'
    },
    cmd = {"TSPlaygroundToggle"},
    config = function()
      vim.api.nvim_set_keymap('n', '<F8>', ":TSPlaygroundToggle<CR>", {noremap=true})
    end,
  }
  use {
    'windwp/nvim-ts-autotag',
    'p00f/nvim-ts-rainbow',
    'romgrk/nvim-treesitter-context',
    -- event = "BufRead",
    requires = {
      'nvim-treesitter/nvim-treesitter'
    }
  }

  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icon
    },
    config = function() require('configs.nvim-tree') end
  }

  use {
    'preservim/nerdcommenter',
    config = function() vim.cmd('filetype plugin on') end
  }

  use {
    'windwp/nvim-autopairs',
    after = 'nvim-cmp',
    config = function() require('configs.autopairs') end
  }
  use { 'tpope/vim-surround' }

  use {
    "folke/twilight.nvim",
    config = function() require("twilight") end
  }

  use {
    'simrat39/symbols-outline.nvim',
    config = function() require('configs.symbols-outline') end,
    requires = {
      {'kyazdani42/nvim-web-devicons', opt = true} -- for file icons
    },
  }

  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-project.nvim',
      'nvim-telescope/telescope-file-browser.nvim',
      {
        "AckslD/nvim-neoclip.lua",
        requires = {'tami5/sqlite.lua', module = 'sqlite'},
        config = function() require('neoclip').setup() end,
      },
    },
    config = function() require('configs.telescope') end
  }

  if PackerBootstrap then
    require('packer').sync()
  end
end}
