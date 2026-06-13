vim.pack.add { { src = 'https://codeberg.org/evergarden/nvim.git', name = 'evergarden' } }

require('evergarden').setup {
  theme = {
    variant = 'winter', -- 'winter'|'fall'|'spring'|'summer'
    accent = 'green',
  },
  editor = {
    cursor = { color = 'accent' },
  },
  style = {
    tabline = { 'reverse' },
    search = { 'reverse' },
    incsearch = {},
    diagnostics = { 'undercurl' },
    types = {},
    keyword = {},
    comment = {},
    spell = { 'undercurl' },
    notes = { 'bold', 'reverse' },
    disable_styles = {},
  },
}

vim.cmd.colorscheme 'evergarden-winter'
