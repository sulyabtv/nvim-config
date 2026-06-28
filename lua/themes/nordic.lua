---@diagnostic disable: undefined-field
vim.pack.add { { src = 'https://github.com/AlexvZyl/nordic.nvim', name = 'nordic' } }

local P = {}

require('nordic').setup {
  after_palette = function(palette)
    P.selection_bg = { bg = palette.gray2 }
    P.dark_bg = { bg = palette.bg_float_border }
    P.dark_fg = { fg = palette.gray1 }
    P.dark = { bg = P.dark_bg.bg, fg = P.dark_fg.fg }
    P.light_bg = { bg = palette.black2 }
    P.light_fg = { fg = palette.blue1 }
    P.light = { bg = P.light_bg.bg, fg = P.light_fg.fg }
    P.light_bg_only = { bg = P.light_bg.bg, fg = P.light_bg.bg }

    palette.bg_visual = P.selection_bg.bg
    vim.api.nvim_set_hl(0, 'SnacksPickerInputBorder', P.dark)
    vim.api.nvim_set_hl(0, 'SnacksPickerListBorder', P.dark)
    vim.api.nvim_set_hl(0, 'SnacksPickerPreviewBorder', P.dark)
    vim.api.nvim_set_hl(0, 'SnacksPickerBoxBorder', P.dark)
    vim.api.nvim_set_hl(0, 'BlinkCmpMenu', P.light)
    vim.api.nvim_set_hl(0, 'BlinkCmpMenuBorder', P.light_bg_only)
    vim.api.nvim_set_hl(0, 'BlinkCmpMenuSelection', P.selection_bg)
    vim.api.nvim_set_hl(0, 'BlinkCmpDocBorder', P.light_bg_only)
    vim.api.nvim_set_hl(0, 'BlinkCmpDocSeparator', P.light)
    vim.api.nvim_set_hl(0, 'NoicePopup', P.light_bg)
  end,
  on_highlight = function(highlights)
    -- Don't make search results bold
    highlights.Search.bold = false
    highlights.IncSearch.bold = false
    -- Fixes that don't seem to work in after_palette
    highlights.NoiceCmdlineIconSearch.bg = P.light.bg
    highlights.NoicePopupBorder.fg = P.light.fg
    highlights.NoicePopupBorder.bg = P.light.bg
    highlights.NoiceCmdlinePopup.bg = P.light.bg
    highlights.BlinkCmpDoc.bg = P.light.bg
  end,
}

vim.cmd.colorscheme 'nordic'
