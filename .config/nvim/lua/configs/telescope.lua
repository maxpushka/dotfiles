local status, telescope = pcall(require, "telescope")
if (not status) then return end

-- Mappings.

local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
-- Global remapping
------------------------------
telescope.setup{
  dynamic_preview_title = true,
  defaults = {
    mappings = {
      n = {
        ["q"] = actions.close
      },
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
              vim.api.nvim_buf_delete(bufnr, {force = true})
            end)
          end
        }
      }
    },
  },
}

-- call load_extension, somewhere after telescope setup function
local neoclip_status, neoclip = pcall(require, "neoclip")
if (neoclip_status) then
  print(neoclip_status)
  neoclip.setup{ enable_persistent_history = true }
  telescope.load_extension('neoclip')
end

telescope.load_extension('project')
telescope.load_extension('file_browser')
telescope.load_extension('git_worktree')
telescope.load_extension('refactoring')
