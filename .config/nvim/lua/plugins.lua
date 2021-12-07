-- Auto install packer.nvim if not exists
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  PackerBootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require('packer').startup{function(use)
  -- Packer can manage itself as an optional plugin
  use { 'wbthomason/packer.nvim' }

  use {
    'tpope/vim-fugitive',
    config = function() require('configs.fugitive') end
  }
  use { 'tpope/vim-rhubarb' }

  use {
    'arcticicestudio/nord-vim',
    config = function() vim.cmd("colorscheme nord") end
  }

  use { 'onsails/lspkind-nvim' }
  use {
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-nvim-lsp", 'hrsh7th/cmp-nvim-lua',
      "hrsh7th/cmp-buffer", 'hrsh7th/cmp-path',
      'hrsh7th/cmp-calc', 'hrsh7th/cmp-emoji',
      'f3fora/cmp-spell', 'octaltree/cmp-look',
      'saadparwaiz1/cmp_luasnip', -- Snippets source for nvim-cmp
      'L3MON4D3/LuaSnip' -- Snippets plugin
    },
  }
  use {
      'tzachar/cmp-tabnine',
      run = './install.sh',
      requires = 'hrsh7th/nvim-cmp'
  }
  use {
    'williamboman/nvim-lsp-installer',
    requires = 'neovim/nvim-lspconfig',
    config = function() require('configs.lspconfig') end
  }

  -- syntax parsers and highlighters
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require('configs.treesitter')
    end
  }
  use {
    'nvim-treesitter/playground',
    config = function()
      vim.api.nvim_set_keymap('n', '<F8>', ":TSPlaygroundToggle<CR>", {noremap=true})
    end,
    cmd = {"TSPlaygroundToggle"}
  }
  use {
    'windwp/nvim-ts-autotag',
    'p00f/nvim-ts-rainbow',
    'romgrk/nvim-treesitter-context',
    requires = {
      'nvim-treesitter/nvim-treesitter'
    },
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
    config = function() require('configs.autopairs') end
  }
  use { 'tpope/vim-surround' }

  use {
    "folke/twilight.nvim",
    config = function() require("twilight") end
  }

  use { 'Yggdroot/indentLine' }

  use {
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    tag = 'release' -- To use the latest release
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
    requires = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-project.nvim' },
    config = function() require('configs.telescope') end
  }
  use {

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
    config = function()
      require'tabline'.setup {
        -- Defaults configuration options
        enable = true,
        options = {
        -- If lualine is installed tabline will use separators configured in lualine by default.
        -- These options can be used to override those settings.
          section_separators = {'', ''},
          component_separators = {'', ''},
          max_bufferline_percent = 66, -- set to nil by default, and it uses vim.o.columns * 2/3
          show_tabs_always = false, -- this shows tabs only when there are more than one tab or if the first tab is named
          show_devicons = true, -- this shows devicons in buffer section
          show_bufnr = false, -- this appends [bufnr] to buffer section,
          show_filename_only = false, -- shows base filename only instead of relative path in filename
        }
      }
      vim.cmd[[
        set guioptions-=e " Use showtabline in gui vim
        set sessionoptions+=tabpages,globals " store tabpages and globals in session
      ]]
      vim.api.nvim_set_keymap('n', '<C-PageUp>', '<cmd>TablineBufferNext<CR>', {noremap = true})
      vim.api.nvim_set_keymap('n', '<C-PageDown>', '<cmd>TablineBufferPrev<CR>', {noremap = true})
    end,
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

  use {
    'nvim-lua/plenary.nvim',
    requires = { 'nvim-lua/popup.nvim' }
  }

  use {
    'norcalli/nvim-colorizer.lua',
    config = function() require('configs.colorizer') end
  }

  use {
    'kyazdani42/nvim-web-devicons',
    config = function()
      require('configs.web_devicons')
    end
  }

  if PackerBootstrap then
    require('packer').sync()
  end
end}
