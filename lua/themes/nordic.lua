vim.pack.add { { src = 'https://github.com/AlexvZyl/nordic.nvim', name = 'nordic' } }

require('nordic').setup {
  after_palette = function(palette)
    -- light visual highlight
    palette.bg_visual = palette.gray1
    -- some handholding for snacks pickers
    local snacks_border = { fg = palette.gray1, bg = palette.bg_float_border }
    vim.api.nvim_set_hl(0, 'SnacksPickerInputBorder', snacks_border)
    vim.api.nvim_set_hl(0, 'SnacksPickerListBorder', snacks_border)
    vim.api.nvim_set_hl(0, 'SnacksPickerPreviewBorder', snacks_border)
    vim.api.nvim_set_hl(0, 'SnacksPickerBoxBorder', snacks_border)
  end,
  on_highlight = function(highlights)
    -- I don't like my search term appearing bold
    highlights.Search.bold = false
    highlights.IncSearch.bold = false
    -- Fix Noice search icon background
    local O = require('nordic.config').options
    local C = require 'nordic.colors'
    ---@diagnostic disable-next-line: undefined-field
    if O.noice.style == 'classic' then highlights.NoiceCmdlineIconSearch.bg = C.bg end
  end,
}

vim.cmd.colorscheme 'nordic'
