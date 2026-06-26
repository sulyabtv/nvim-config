vim.pack.add { { src = 'https://codeberg.org/evergarden/nvim.git', name = 'evergarden' } }

require('evergarden').setup {
  theme = {
    variant = 'winter', -- 'winter'|'fall'|'spring'|'summer'
    accent = 'green',
  },
  style = {
    disable_styles = { 'italic' },
  },
}

-- vim.cmd.colorscheme 'evergarden-winter'
