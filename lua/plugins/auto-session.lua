vim.pack.add { 'https://github.com/rmagatti/auto-session' }

require('auto-session').setup {
  pre_save_cmds = { 'ScopeSaveState' },
  post_restore_cmds = { 'ScopeLoadState', function() Snacks.explorer.open { focus = false } end },
}

vim.keymap.set('n', '<leader>sr', '<cmd>AutoSession search<cr>', { desc = 'Search sessions' })
vim.keymap.set('n', '<leader>ss', '<cmd>AutoSession save<cr>', { desc = 'Save session' })
vim.keymap.set('n', '<leader>sa', '<cmd>AutoSession toggle<cr>', { desc = 'Toggle autosave' })
