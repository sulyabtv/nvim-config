-- Allows scrolling past EOF
vim.pack.add { 'https://github.com/Aasim-A/scrollEOF.nvim' }

-- Configure scrolloff here because this plugin relies on the scrolloff value
-- at plugin initialization
vim.o.scrolloff = 10

require('scrollEOF').setup {
  -- Keep scrolloff active in insert mode as well
  insert_mode = true,
}
