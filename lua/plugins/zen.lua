vim.pack.add { 'https://github.com/folke/zen-mode.nvim' }

require('zen-mode').setup {
  plugins = {
    options = {
      laststatus = 0, -- hide the statusline in zen mode
    },
    tmux = { enabled = true }, -- hide tmux status line
  },
}

vim.keymap.set('n', '<leader>z', '<cmd>ZenMode<cr>', { desc = 'Toggle Zen Mode' })
