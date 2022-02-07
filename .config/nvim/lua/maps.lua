-- Description: Keymaps
local set_keymap = vim.api.nvim_set_keymap

set_keymap("n", "<S-C-p>", "\"0p", {noremap = true})
-- Delete without yank
set_keymap("n", "<leader>d", "\"_d", {noremap = true})
set_keymap("n", "x", "\"_x",         {noremap = true})

-- Increment/decrement
set_keymap("n", "+", "<C-a>", {noremap = true})
set_keymap("n", "-", "<C-x>", {noremap = true})

-- Move lines
set_keymap("n", "<A-j>", ":m .+1<CR>==",        {noremap = true})
set_keymap("n", "<A-k>", ":m .-2<CR>==",        {noremap = true})
set_keymap("i", "<A-j>", "<Esc>:m .+1<CR>==gi", {noremap = true})
set_keymap("i", "<A-k>", "<Esc>:m .-2<CR>==gi", {noremap = true})
set_keymap("v", "<A-j>", ":m '>+1<CR>gv=gv",    {noremap = true})
set_keymap("v", "<A-k>", ":m '<-2<CR>gv=gv",    {noremap = true})

set_keymap("n", "<C-a>", "gg<S-v>G", {})  -- Select all the content of current buffer
set_keymap("n", "<C-c>", "gg<S-v>Gy", {}) -- Copy all the content of current buffer

-- Save with root permission
vim.cmd("command! W w !sudo tee > /dev/null %")

-- Save file
set_keymap("n", "<C-s>", ":update<cr>", {noremap = true})
set_keymap("i", "<C-s>", "<Esc>:update<cr>gi", {noremap = true})

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
set_keymap("n", "[t", ":tabprev<Return>", {})
set_keymap("n", "]t", ":tabnext<Return>", {})

-------------------------------
-- Windows

-- Split window
set_keymap("n", "ss", ":split<Return><C-w>w",  {noremap=true})
set_keymap("n", "sv", ":vsplit<Return><C-w>w", {noremap=true})
set_keymap("n", "sd", ":Bdelete<CR>",          {noremap=true})
-- Move window
set_keymap("", "<C-left>",  "<C-w>h", {})
set_keymap("", "<C-up>",    "<C-w>k", {})
set_keymap("", "<C-down>",  "<C-w>j", {})
set_keymap("", "<C-right>", "<C-w>l", {})
set_keymap("", "<C-h>",     "<C-w>h", {})
set_keymap("", "<C-k>",     "<C-w>k", {})
set_keymap("", "<C-j>",     "<C-w>j", {})
set_keymap("", "<C-l>",     "<C-w>l", {})
-- Resize window
set_keymap("n", "<C-w><left>",  "<C-w><", {})
set_keymap("n", "<C-w><right>", "<C-w>>", {})
set_keymap("n", "<C-w><up>",    "<C-w>+", {})
set_keymap("n", "<C-w><down>",  "<C-w>-", {})

set_keymap("n", "<Esc>", ":noh<return>", {noremap = true})
