if !exists('g:loaded_nvim_treesitter')
  echom "Not loaded treesitter"
  finish
endif

lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    disable = {},
  },
  indent = {
    enable = false,
    disable = {},
  },
  ensure_installed = {
    "tsx",
    "toml",
    "bash",
    "php",
    "javascript",
    "typescript",
    "json",
    "yaml",
    "html",
    "scss",
    "css",
    "python",
    "c_sharp",
    "c",
    "cpp",
    "cmake",
    "dockerfile",
    "regex",
    "lua"
  },
}

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.tsx.used_by = { "javascript", "typescript.tsx" }
EOF
