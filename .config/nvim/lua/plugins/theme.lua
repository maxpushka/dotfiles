---@type LazySpec
return {
  {
    "f-person/auto-dark-mode.nvim",
    lazy = false,
    priority = 900,
    opts = {
      update_interval = 3000,
      -- explicit callbacks required; without them auto-dark-mode mutates vim.o.background after astroui
      -- sets the colorscheme at startup, clobbering it
      set_dark_mode = function()
        require("catppuccin").setup({ flavour = "mocha" })
        vim.cmd.colorscheme "catppuccin"
      end,
      set_light_mode = function()
        require("catppuccin").setup({ flavour = "latte" })
        vim.cmd.colorscheme "catppuccin"
      end,
    },
  },
}
