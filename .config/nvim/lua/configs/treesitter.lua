local present, ts_configs = pcall(require, "nvim-treesitter.configs")
if not present then
  return
end

ts_configs.setup {
  highlight = {
    enable = true,
    use_languagetree = true,
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

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.tsx.filetype_to_parsername = { "javascript", "typescript.tsx" }

require("nvim-treesitter.install").prefer_git = true
