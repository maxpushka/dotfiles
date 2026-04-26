-- Neovim 0.11+ enables DEC mode 2031 on UIEnter and updates `vim.o.background`
-- when Ghostty (or any terminal that speaks the protocol) sends DSR 997.
-- cyberdream's `variant = "auto"` reads `&background` at colorscheme load,
-- so the right variant is picked at session start. For mid-session flips,
-- use `<leader>ub` (AstroCore's `toggles.background`).

---@type LazySpec
return {
  {
    "scottmckendry/cyberdream.nvim",
    opts = { variant = "auto" },
  },
}
