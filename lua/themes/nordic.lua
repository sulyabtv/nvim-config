vim.pack.add { { src = 'https://github.com/AlexvZyl/nordic.nvim', name = 'nordic' } }

require('nordic').setup {
  after_palette = function(palette) palette.fg_float_border = palette.gray2 end,
  on_highlight = function(highlights)
    -- I don't like my search term appearing bold
    highlights.Search.bold = false
    highlights.Search.underline = false
    highlights.IncSearch.bold = false
    -- Fix Noice search icon background
    local O = require('nordic.config').options
    local C = require 'nordic.colors'
    ---@diagnostic disable-next-line: undefined-field
    if O.noice.style == 'classic' then highlights.NoiceCmdlineIconSearch.bg = C.bg end
  end,
}

vim.cmd.colorscheme 'nordic'
