-- Description: Keymaps
local set_keymap = require('utils').set_keymap

set_keymap("n", ";", ":", { silent = false })

-- Delete without yank
set_keymap("n", "<leader>d", "\"_d")
set_keymap("n", "x", "\"_x")
-- Don't copy the replaced text after pasting in visual mode
set_keymap("v", "p", '"_dP')
set_keymap("n", "<S-C-p>", "\"0p")

-- Increment/decrement
set_keymap("n", "+", "<C-a>")
set_keymap("n", "-", "<C-x>")

-- Move lines
set_keymap("n", "<A-j>", ":m .+1<CR>==")
set_keymap("n", "<A-k>", ":m .-2<CR>==")
set_keymap("i", "<A-j>", "<Esc>:m .+1<CR>==gi")
set_keymap("i", "<A-k>", "<Esc>:m .-2<CR>==gi")
set_keymap("v", "<A-j>", ":m '>+1<CR>gv=gv")
set_keymap("v", "<A-k>", ":m '<-2<CR>gv=gv")

set_keymap("n", "<C-a>", "gg<S-v>G") -- Select all the content of current buffer
set_keymap("n", "<C-c>", "gg<S-v>Gy") -- Copy all the content of current buffer

-- Save with root permission
vim.cmd("command! W w !sudo tee > /dev/null %")

-- Save file
set_keymap("n", "<C-s>", ":update<cr>")
set_keymap("i", "<C-s>", "<Esc>:update<cr>gi")

-- Search for selected text, forwards or backwards.
vim.cmd([[
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
]])

------------------------------
-- Tabs
set_keymap("n", "[t", ":tabprev<CR>")
set_keymap("n", "]t", ":tabnext<CR>")

-------------------------------
-- Windows

-- Split window
set_keymap("n", "<leader>bh", ":split<CR><C-w>w")
set_keymap("n", "<leader>bv", ":vsplit<CR><C-w>w")
-- Move window
set_keymap("", "<C-left>", "<C-w>h")
set_keymap("", "<C-up>", "<C-w>k")
set_keymap("", "<C-down>", "<C-w>j")
set_keymap("", "<C-right>", "<C-w>l")
set_keymap("", "<C-h>", "<C-w>h")
set_keymap("", "<C-k>", "<C-w>k")
set_keymap("", "<C-j>", "<C-w>j")
set_keymap("", "<C-l>", "<C-w>l")
-- Resize window
set_keymap("n", "<C-w><left>", "<C-w><")
set_keymap("n", "<C-w><right>", "<C-w>>")
set_keymap("n", "<C-w><up>", "<C-w>+")
set_keymap("n", "<C-w><down>", "<C-w>-")

set_keymap("n", "<Esc>", ":noh<return>")
