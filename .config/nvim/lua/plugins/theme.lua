---@type LazySpec
return {
  {
    "f-person/auto-dark-mode.nvim",
    lazy = false,
    priority = 900,
    opts = {
      update_interval = 3000,
      -- fallback = "dark",
    },
  },
}
