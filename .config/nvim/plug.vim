if has("nvim")
  let g:plug_home = stdpath('data') . '/plugged'
endif

call plug#begin()

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'

if has("nvim")
  Plug 'neovim/nvim-lspconfig'
  Plug 'kabouzeid/nvim-lspinstall'

  " nvim-cmp
  Plug 'wbthomason/packer.nvim'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
    " For luasnip users.
  Plug 'L3MON4D3/LuaSnip'
  Plug 'saadparwaiz1/cmp_luasnip'

  " coc
  "Plug 'neoclide/coc.nvim', {'branch': 'release'}
  "Plug 'fannheyward/telescope-coc.nvim'

  Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' } " syntax parsers and highlighters
  Plug 'nvim-treesitter/playground'

  Plug 'preservim/nerdcommenter'
  Plug 'windwp/nvim-autopairs'
  Plug 'Yggdroot/indentLine' " display indentation levels
  Plug 'p00f/nvim-ts-rainbow' " bracket colorizer
  Plug 'windwp/nvim-ts-autotag' " auto close and auto rename html tag

  Plug 'preservim/nerdtree'
  Plug 'ryanoasis/vim-devicons'

  Plug 'nvim-telescope/telescope.nvim'
  Plug 'hoob3rt/lualine.nvim'
  "Plug 'tami5/lspsaga.nvim' "Plug 'glepnir/lspsaga.nvim' " requires 'neovim/nvim-lspconfig'
  Plug 'folke/lsp-colors.nvim'
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'nvim-lua/plenary.nvim' " requires 'popup.nvim'
  Plug 'nvim-lua/popup.nvim'
  Plug 'norcalli/nvim-colorizer.lua'
endif

call plug#end()

