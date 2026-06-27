vim.pack.add { 'https://github.com/rmagatti/auto-session' }

vim.o.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal'

require('auto-session').setup {
  post_restore_cmds = { function() Snacks.explorer.open { focus = false } end },
}

-- session picker (their <leader>p, or pick your own key)
vim.keymap.set('n', '<leader>sr', '<cmd>AutoSession search<cr>', { desc = 'Search sessions' })
vim.keymap.set('n', '<leader>ss', '<cmd>AutoSession save<cr>', { desc = 'Save session' })
vim.keymap.set('n', '<leader>sa', '<cmd>AutoSession toggle<cr>', { desc = 'Toggle autosave' })
