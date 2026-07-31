vim.pack.add {
  { src = 'https://github.com/s1n7ax/nvim-window-picker' },
}

require('window-picker').setup {
  hint = 'floating-letter',
  show_prompt = false,
  filter_rules = {
    autoselect_one = true,
    bo = {
      -- ignore windows with the following filetypes
      filetype = {
        'NvimTree',
        'neo-tree',
        'notify',
        'snacks_notif',
        'snacks_layout_box',
        'snacks_picker_input',
      },
      -- ignore windows with the following buftypes
      buftype = {
        'terminal',
      },
    },
  },
}

vim.keymap.set('n', '<leader>w', function()
  local win = require('window-picker').pick_window()
  if win then vim.api.nvim_set_current_win(win) end
end, { desc = 'Pick window' })
