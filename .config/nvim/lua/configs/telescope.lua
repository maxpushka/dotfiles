local status, telescope = pcall(require, "telescope")
if (not status) then return end

-- Mappings.

local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

-- prompt_bufnr is required to fulfill interface
---@diagnostic disable-next-line: unused-local
local ts_select_dir_for_grep = function(prompt_bufnr)
  -- local action_state = require("telescope.actions.state")
  local fb = require("telescope").extensions.file_browser
  local live_grep = require("telescope.builtin").live_grep
  local current_line = action_state.get_current_line()

  fb.file_browser({
    files = false,
    depth = false,
    -- prompt_bufnr is required to fulfill interface
    ---@diagnostic disable-next-line: unused-local, redefined-local
    attach_mappings = function(prompt_bufnr)
      require("telescope.actions").select_default:replace(function()
        local entry_path = action_state.get_selected_entry().Path
        local dir = entry_path:is_dir() and entry_path or entry_path:parent()
        local relative = dir:make_relative(vim.fn.getcwd())
        local absolute = dir:absolute()

        live_grep({
          results_title = relative .. "/",
          cwd = absolute,
          default_text = current_line,
        })
      end)

      return true
    end,
  })
end

-- Global remapping
------------------------------
telescope.setup {
  dynamic_preview_title = true,
  defaults = {
    sorting_strategy = "ascending",
    layout_config = {
      prompt_position = 'top',
    },
    mappings = {
      n = {
        ["q"] = actions.close
      },
    },
    file_ignore_patterns = {
      "vendor/*",
      "package-lock.json",
      "%.lock",
      "__pycache__/*",
      -- "%.sqlite3",
      -- "%.ipynb",
      "node_modules/*",
      -- "%.jpg",
      -- "%.jpeg",
      -- "%.png",
      -- "%.svg",
      -- "%.otf",
      -- "%.ttf",
      ".git/",
      -- "%.webp",
      ".dart_tool/",
      -- ".github/",
      -- ".gradle/",
      ".idea/",
      -- ".settings/",
      ".vscode/",
      "__pycache__/",
      "build/",
      -- "env/",
      "gradle/",
      "node_modules/",
      "target/",
      -- "%.pdb",
      -- "%.dll",
      -- "%.class",
      -- "%.exe",
      -- "%.cache",
      -- "%.ico",
      -- "%.pdf",
      -- "%.dylib",
      -- "%.jar",
      -- "%.docx",
      -- "%.met",
      "smalljre_*/*",
      ".vale/",
    },
  },
  pickers = {
    find_files = {
      hidden = true,
    },
    file_browser = {
      hidden = true,
    },
    live_grep = {
      hidden = true,
      mappings = {
        i = {
          ["<C-d>"] = ts_select_dir_for_grep,
        },
        n = {
          ["<C-d>"] = ts_select_dir_for_grep,
        },
      },
    },
    buffers = {
      mappings = {
        i = {
          ["<C-x>"] = function(prompt_bufnr)
            local current_picker = action_state.get_current_picker(prompt_bufnr)
            local selected_bufnr = action_state.get_selected_entry().bufnr

            --- get buffers with lower number, with next highest ("bprevious") selected first
            local replacement_buffers = {}
            for entry in current_picker.manager:iter() do
              if entry.bufnr < selected_bufnr then
                table.insert(replacement_buffers, 1, entry.bufnr)
              end
            end

            current_picker:delete_selection(function(selection)
              local bufnr = selection.bufnr
              -- get associated window(s)
              local winids = vim.fn.win_findbuf(bufnr)
              -- verify to only close windows with current buffer
              local tabwins = vim.api.nvim_tabpage_list_wins(0)
              -- fill winids with new empty buffers
              for _, winid in ipairs(winids) do
                if vim.tbl_contains(tabwins, winid) then
                  local new_buf = vim.F.if_nil(table.remove(replacement_buffers),
                    -- if no alternative available, create unlisted scratch buffer
                    vim.api.nvim_create_buf(false, true))
                  vim.api.nvim_win_set_buf(winid, new_buf)
                end
              end
              -- remove buffer at last
              vim.api.nvim_buf_delete(bufnr, { force = true })
            end)
          end
        }
      }
    },
  },
}

telescope.load_extension('project')
telescope.load_extension('file_browser')
telescope.load_extension('git_worktree')
telescope.load_extension('refactoring')
telescope.load_extension('neoclip')
telescope.load_extension('notify')
