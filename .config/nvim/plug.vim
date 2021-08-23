if has("nvim")
  let g:plug_home = stdpath('data') . '/plugged'
endif

call plug#begin()

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'cohama/lexima.vim'
Plug 'AndrewRadev/tagalong.vim'

if has("nvim")
  Plug 'neovim/nvim-lspconfig'
  Plug 'kabouzeid/nvim-lspinstall'
  Plug 'nvim-lua/completion-nvim' " lsp completion and language servers
  Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' } " syntax parsers and highlighters
  Plug 'nvim-treesitter/playground'
  Plug 'ThePrimeagen/refactoring.nvim' " requires 'nvim-treesitter' and 'plenary.nvim'
  Plug 'preservim/nerdcommenter'

  Plug 'hoob3rt/lualine.nvim'
  Plug 'glepnir/lspsaga.nvim'
  Plug 'folke/lsp-colors.nvim'
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'nvim-lua/plenary.nvim' " requires 'popup.nvim'
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' } " requires golang installed
endif

call plug#end()

