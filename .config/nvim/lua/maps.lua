-- Description: Keymaps
local map = vim.api.nvim_set_keymap

map("n", "<S-C-p>", "\"0p", {noremap = true})
-- Delete without yank
map("n", "<leader>d", "\"_d", {noremap = true})
map("n", "x", "\"_x", {noremap = true})

-- Increment/decrement
map("n", "+", "<C-a>", {noremap = true})
map("n", "-", "<C-x>", {noremap = true})

-- Move lines
map("n", "<A-j>", ":m .+1<CR>==", {noremap = true})
map("n", "<A-k>", ":m .-2<CR>==", {noremap = true})
map("i", "<A-j>", "<Esc>:m .+1<CR>==gi", {noremap = true})
map("i", "<A-k>", "<Esc>:m .-2<CR>==gi", {noremap = true})
map("v", "<A-j>", ":m '>+1<CR>gv=gv", {noremap = true})
map("v", "<A-k>", ":m '<-2<CR>gv=gv", {noremap = true})

-- Select all
map("n", "<C-a>", "gg<S-v>G", {})

-- Save with root permission
vim.cmd("command! W w !sudo tee > /dev/null %")

-- Save file
map("n", "<C-s>", ":update<cr>", {noremap = true})
map("i", "<C-s>", "<Esc>:update<cr>gi", {noremap = true})

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

-- Open current directory
map("n", "et", ":tabedit", {})
map("n", "<S-Tab>", ":tabprev<Return>", {})
map("n", "<Tab>", ":tabnext<Return>", {})

-------------------------------
-- Windows

-- Split window
map("n", "ss", ":split<Return><C-w>w", {})
map("n", "sv", ":vsplit<Return><C-w>w", {})
-- Move window
--map("nvo", "<Space>", "<C-w>w", {})
map("", "s<left>", "<C-w>h", {})
map("", "s<up>", "<C-w>k", {})
map("", "s<down>", "<C-w>j", {})
map("", "s<right>", "<C-w>l", {})
map("", "sh", "<C-w>h", {})
map("", "sk", "<C-w>k", {})
map("", "sj", "<C-w>j", {})
map("", "sl", "<C-w>l", {})
-- Resize window
map("n", "<C-w><left>", "<C-w><", {})
map("n", "<C-w><right>", "<C-w>>", {})
map("n", "<C-w><up>", "<C-w>+", {})
map("n", "<C-w><down>", "<C-w>-", {})

map("n", "<esc><esc>", ":noh<return>", {noremap = true})
