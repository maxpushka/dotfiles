local present, bufferline = pcall(require, 'bufferline')
if not present then return end

vim.opt.termguicolors = true
vim.api.nvim_set_keymap('n', ']b', ':BufferLineCycleNext<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '[b', ':BufferLineCyclePrev<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', ']B', ':BufferLineMoveNext<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '[B', ':BufferLineMovePrev<CR>', {noremap = true, silent = true})

bufferline.setup {
   options = {
      offsets = { { filetype = "NvimTree", text = "", padding = 1 } },
      buffer_close_icon = "",
      modified_icon = "",
      close_icon = "",
      show_close_icon = true,
      left_trunc_marker = "",
      right_trunc_marker = "",
      max_name_length = 14,
      max_prefix_length = 13,
      tab_size = 20,
      show_tab_indicators = true,
      enforce_regular_tabs = true,
      view = "multiwindow",
      show_buffer_close_icons = true,
      separator_style = "thin",
      always_show_bufferline = true,
      diagnostics = false,
      custom_filter = function(buf_number)
         -- Func to filter out our managed/persistent split terms
         local present_type, type = pcall(function()
            return vim.api.nvim_buf_get_var(buf_number, "term_type")
         end)

         if present_type then
            if type == "vert" then
               return false
            elseif type == "hori" then
               return false
            end
            return true
         end

         return true
      end,
   },
}
