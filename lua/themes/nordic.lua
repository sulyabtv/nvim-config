---@diagnostic disable: undefined-field
vim.pack.add { { src = 'https://github.com/AlexvZyl/nordic.nvim', name = 'nordic' } }

local P = {}

require('nordic').setup {
  after_palette = function(palette)
    P.selection_bg = { bg = palette.gray2 }
    P.selection_bg_light = { bg = palette.gray2 }
    P.dark_bg = { bg = palette.bg_float_border }
    P.dark_fg = { fg = palette.gray1 }
    P.dark = { bg = P.dark_bg.bg, fg = P.dark_fg.fg }
    P.light_bg = { bg = palette.black2 }
    P.light_fg = { fg = palette.blue1 }
    P.light = { bg = P.light_bg.bg, fg = P.light_fg.fg }
    P.light_bg_only = { bg = P.light_bg.bg, fg = P.light_bg.bg }
    P.orig_normal_float = { fg = palette.fg_float, bg = palette.bg_float }
    P.comment = { fg = palette.gray5 }

    palette.bg_visual = P.selection_bg.bg
    palette.comment = P.comment.fg
    -- We will override NormalFloat, so set things that
    -- actually need NormalFloat to a clone of it
    vim.api.nvim_set_hl(0, 'SnacksPicker', P.orig_normal_float)
    vim.api.nvim_set_hl(0, 'SnacksNormal', P.orig_normal_float)
    vim.api.nvim_set_hl(0, 'SnacksNormalNC', P.orig_normal_float)
    vim.api.nvim_set_hl(0, 'WhichKeyNormal', P.orig_normal_float)
    -- Other fixes
    vim.api.nvim_set_hl(0, 'SnacksPickerInputBorder', P.dark)
    vim.api.nvim_set_hl(0, 'SnacksPickerListBorder', P.dark)
    vim.api.nvim_set_hl(0, 'SnacksPickerPreviewBorder', P.dark)
    vim.api.nvim_set_hl(0, 'SnacksPickerBoxBorder', P.dark)
    vim.api.nvim_set_hl(0, 'BlinkCmpMenu', P.light)
    vim.api.nvim_set_hl(0, 'BlinkCmpMenuBorder', P.light_bg_only)
    vim.api.nvim_set_hl(0, 'BlinkCmpMenuSelection', { bg = palette.gray1 })
    vim.api.nvim_set_hl(0, 'BlinkCmpDocBorder', P.light_bg_only)
    vim.api.nvim_set_hl(0, 'BlinkCmpDocSeparator', P.light)
    vim.api.nvim_set_hl(0, 'NoicePopup', P.light_bg)

    -- Terminal colors, mainly here for lazygit
    vim.g.terminal_color_0 = palette.black0
    vim.g.terminal_color_1 = palette.red.base
    vim.g.terminal_color_2 = palette.green.base
    vim.g.terminal_color_3 = palette.yellow.base
    vim.g.terminal_color_4 = palette.blue0
    vim.g.terminal_color_5 = palette.magenta.base
    vim.g.terminal_color_6 = palette.cyan.base
    vim.g.terminal_color_7 = palette.white1
    vim.g.terminal_color_8 = palette.gray1
    vim.g.terminal_color_9 = palette.red.bright
    vim.g.terminal_color_10 = palette.green.bright
    vim.g.terminal_color_11 = palette.yellow.bright
    vim.g.terminal_color_12 = palette.blue2
    vim.g.terminal_color_13 = palette.magenta.bright
    vim.g.terminal_color_14 = palette.cyan.bright
    vim.g.terminal_color_15 = palette.white3
  end,

  on_highlight = function(highlights)
    -- Don't make search results bold
    highlights.Search.bold = false
    highlights.IncSearch.bold = false
    -- Fix LSP-related highlighting
    highlights.LspReferenceRead = P.selection_bg_light
    highlights.LspReferenceWrite = P.selection_bg_light
    highlights.LspReferenceText = P.selection_bg_light
    highlights.LspSignatureActiveParameter.bg = P.light.bg
    -- Other fixes
    highlights.FloatBorder = P.light_bg_only
    highlights.NormalFloat.bg = P.light.bg
    highlights.NoiceCmdlineIconSearch.bg = P.light.bg
    highlights.NoicePopupBorder.fg = P.light.fg
    highlights.NoicePopupBorder.bg = P.light.bg
    highlights.NoiceCmdlinePopup.bg = P.light.bg
    highlights.BlinkCmpDoc.bg = P.light.bg
  end,
}

vim.cmd.colorscheme 'nordic'
