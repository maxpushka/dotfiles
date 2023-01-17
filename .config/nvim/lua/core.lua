-- Fundamentals --{{{
-- ---------------------------------------------------------------------

vim.g.mapleader = " "

vim.o.swapfile = false
vim.opt.compatible = false
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = "a"
vim.api.nvim_command("syntax enable")
vim.o.fileencodings = "utf-8,sjis,euc-jp,latin,cp1251,koi8-r,cp866"
vim.o.encoding = "utf-8"
vim.o.guifont = "*"
vim.o.guifontwide = "*"
vim.o.backup = false
vim.o.hlsearch = true
vim.o.showcmd = true
vim.o.cmdheight = 1
vim.o.laststatus = 3
vim.o.scrolloff = 10
vim.o.expandtab = true
--vim.o.loaded_matchparen = 1
vim.o.shell = "bash"
vim.o.backupskip = "/tmp/*,/private/tmp/*"

-- incremental substitution
vim.o.inccommand = "split"

-- Suppress appending <PasteStart> and <PasteEnd> when pasting
--vim.o.t_BE=''

vim.o.sc = false
vim.o.ru = false
vim.o.sm = false

-- Don't redraw while executing macros (good performance config)
vim.o.lazyredraw = true
--vim.o.mat=2 -- How many tenths of a second to blink when matching brackets
vim.o.ignorecase = true -- Ignore case when searching
vim.o.smarttab = true -- Be smart when using tabs ;)
-- indents
vim.api.nvim_command("filetype plugin indent on")
vim.o.autoindent = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.ai = true -- Auto indent
vim.o.si = true -- Smart indent
vim.o.wrap = false -- No Wrap lines
vim.o.backspace = "start,eol,indent"
vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldlevel = 100
-- Finding files - Search down into subfolders
vim.opt.path:append("**")
vim.opt.wildignore:append("*/node_modules/*")

-- Turn off paste mode when leaving insert
vim.cmd("autocmd InsertLeave * set nopaste")

-- Add asterisks in block comments
vim.opt.formatoptions:append("r")

-- if set, when we switch between buffers, it will not split more than once. It will switch to the existing buffer instead
vim.opt.switchbuf = "useopen"

vim.o.exrc = true
vim.o.clipboard = "unnamedplus"

vim.cmd([[
  " trigger `autoread` when files changes on disk
    set autoread
    autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
  " notification after file change
    autocmd FileChangedShellPost *
      \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None
]])
--}}}

-- Highlights --{{{
-- ---------------------------------------------------------------------

vim.o.cursorline = true
--set cursorcolumn

vim.o.colorcolumn = 120

--}}}

-- File types --{{{
-- ---------------------------------------------------------------------

vim.api.nvim_command([[
" JavaScript
au BufNewFile,BufRead *.es6 setf javascript
" TypeScript
au BufNewFile,BufRead *.tsx setf typescriptreact
" Markdown
au BufNewFile,BufRead *.md set filetype=markdown
" Flow
au BufNewFile,BufRead *.flow set filetype=javascript

set suffixesadd=.js,.es,.jsx,.json,.css,.less,.sass,.styl,.php,.py,.md

autocmd FileType * setlocal shiftwidth=4 tabstop=4

autocmd FileType coffee setlocal shiftwidth=2 tabstop=2
autocmd FileType ruby   setlocal shiftwidth=2 tabstop=2
autocmd FileType yaml   setlocal shiftwidth=2 tabstop=2

autocmd FileType javascript      setlocal shiftwidth=4 tabstop=4
autocmd FileType typescript      setlocal shiftwidth=4 tabstop=4
autocmd FileType javascriptreact setlocal shiftwidth=4 tabstop=4
autocmd FileType typescriptreact setlocal shiftwidth=4 tabstop=4
]])

--}}}

-- Imports --{{{
-- ---------------------------------------------------------------------

if vim.fn.has("unix") then
	if vim.fn.system("uname -s") == "Darwin\n" then
		require("macos")
	elseif string.find(vim.fn.system("uname -r"), "microsoft") then
		require("wsl")
	end
end

--}}}

-- Syntax theme --{{{
-- ---------------------------------------------------------------------

-- true color
if vim.fn.exists("&termguicolors") and vim.fn.exists("&winblend") then
	vim.cmd("syntax enable")
	vim.o.termguicolors = true
	vim.o.winblend = 0
	vim.o.wildoptions = "pum"
	vim.o.pumblend = 5
	vim.o.background = "dark"
	-- Use NeoSolarized
	--vim.g.neosolarized_termtrans = 1
	--vim.cmd('runtime ./colors/NeoSolarized.vim')
	--vim.cmd("colorscheme NeoSolarized")
end

--}}}

-- Extras --{{{
-- ---------------------------------------------------------------------

--}}}
