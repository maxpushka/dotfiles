local status, nvim_tree = pcall(require, "nvim-tree")
if (not status) then return end

local g = vim.g

g.loaded_netrw       = 1
g.loaded_netrwPlugin = 1

nvim_tree.setup {
  filters = {
    dotfiles = false,
  },
  disable_netrw = false,
  hijack_netrw = true,
  open_on_tab = false,
  hijack_cursor = true,
  update_cwd = true,
  update_focused_file = {
    enable = true,
    update_cwd = false,
    ignore_list = {}
  },
  actions = {
    open_file = {
      quit_on_open = false,
      window_picker = {
        exclude = {
          filetype = { "notify", "packer", "qf" },
          buftype = { "terminal" },
        }
      }
    }
  },
  diagnostics = {
    enable = true,
    show_on_dirs = true,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    }
  },
  view = {
    side = "left",
    width = 40,
    hide_root_folder = true,
    relativenumber = true
  },
  git = {
    enable = true,
    ignore = false,
  },
  renderer = {
    icons = {
      glyphs = {
        default = "",
        symlink = "",
        git = {
          deleted = "",
          ignored = "◌",
          renamed = "➜",
          staged = "✓",
          unmerged = "",
          unstaged = "✗",
          untracked = "★",
        },
        folder = {
          default = "",
          empty = "",
          empty_open = "",
          open = "",
          symlink = "",
          symlink_open = "",
        },
      },
    },
    indent_markers = {
      enable = true,
    },
    root_folder_modifier = table.concat { ":t:gs?$?/..", string.rep(" ", 1000), "?:gs?^??" },
  },
}

local function open_nvim_tree(data)
  local IGNORED_FT = {
    "dashboard",
  }

  -- buffer is a real file on the disk
  local real_file = vim.fn.filereadable(data.file) == 1

  -- buffer is a [No Name]
  local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

  -- &ft
  local filetype = vim.bo[data.buf].ft

  -- only files please
  if not real_file and not no_name then
    return
  end

  -- skip ignored filetypes
  if vim.tbl_contains(IGNORED_FT, filetype) then
    return
  end

  -- open the tree but don't focus it
  require("nvim-tree.api").tree.toggle({ focus = false })
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
