-- if true then return end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

vim.opt.wrap = true
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    vim.keymap.del("n", "<leader>l")
    vim.keymap.del("n", "<leader>cd")
    vim.keymap.del("n", "<leader>cf")
  end,
})
