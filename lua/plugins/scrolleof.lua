-- allows scrolling past EOF so line centering works even at the end of the document
vim.pack.add { 'https://github.com/Aasim-A/scrollEOF.nvim' }
require('scrollEOF').setup {}
