if not vim.fn.exists('g:loaded_nvim_treesitter') then
  print("Not loaded treesitter")
  return
end

require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    disable = {},
  },
  indent = {
    enable = true,
    disable = {},
  },
  ensure_installed = {
    "tsx",
    "toml",
    "bash",
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
    "lua",
    "query",
    "jsdoc",
    "latex",
    "vim",
    "ruby",
    "go"
  },
  rainbow = { -- p00f/nvim-ts-rainbow plugin
    enable = true,
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = nil, -- Do not enable for files with more than n lines, int
  },
  autotag = { -- windwp/nvim-ts-autotag plugin
    enable = true,
  }
}

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.tsx.used_by = { "javascript", "typescript.tsx" }