vim.pack.add { 'https://github.com/rmagatti/auto-session' }

vim.o.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'

require('auto-session').setup {
  pre_save_cmds = { 'Neotree close' },
  post_restore_cmds = { 'Neotree filesystem show' },
}

-- session picker (their <leader>p, or pick your own key)
vim.keymap.set('n', '<leader>sr', '<cmd>AutoSession search<cr>', { desc = 'Search sessions' })
vim.keymap.set('n', '<leader>ss', '<cmd>AutoSession save<cr>', { desc = 'Save session' })
vim.keymap.set('n', '<leader>sa', '<cmd>AutoSession toggle<cr>', { desc = 'Toggle autosave' })
