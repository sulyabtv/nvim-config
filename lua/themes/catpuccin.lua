vim.pack.add { { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' } }

require('catppuccin').setup {
  integrations = {
    snacks = { enabled = true },
  },
}

-- vim.cmd.colorscheme 'catppuccin-mocha'
