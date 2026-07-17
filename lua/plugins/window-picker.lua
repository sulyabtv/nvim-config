vim.pack.add {
  { src = 'https://github.com/s1n7ax/nvim-window-picker' },
}

require('window-picker').setup {
  hint = 'floating-letter',
  show_prompt = false,
  filter_rules = {
    include_current_win = false,
    autoselect_one = true,
  },
}

vim.keymap.set('n', '<leader>w', function()
  local win = require('window-picker').pick_window()
  if win then vim.api.nvim_set_current_win(win) end
end, { desc = 'Pick window' })
