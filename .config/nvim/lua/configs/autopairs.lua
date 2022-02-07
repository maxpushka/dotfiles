local present1, autopairs = pcall(require, "nvim-autopairs")
local present2, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")

if present1 and present2 then
  local default = {
    fast_wrap = {},
    disable_filetype = { "TelescopePrompt" , "vim" },
    map_cr = true,
  }
  autopairs.setup(default)

  local cmp = require "cmp"
  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end
