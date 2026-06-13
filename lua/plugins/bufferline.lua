vim.pack.add {
  'https://github.com/akinsho/bufferline.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
}

local bufferline = require 'bufferline'

bufferline.setup {
  options = {
    mode = 'buffers', -- show buffers as tabs
    style_preset = {
      bufferline.style_preset.no_italic,
    },
    diagnostics = 'nvim_lsp', -- show LSP diagnostic counts on tabs
    separator_style = 'slant',
    always_show_bufferline = true,
    offsets = {
      {
        -- no tabs on the neo-tree window
        filetype = 'neo-tree',
        highlight = 'Directory',
      },
    },
  },
}

-- buffer cycling
vim.keymap.set('n', '<Tab>', '<cmd>BufferLineCycleNext<cr>', { desc = 'Next buffer' })
vim.keymap.set('n', '<S-Tab>', '<cmd>BufferLineCyclePrev<cr>', { desc = 'Prev buffer' })

-- buffer navigation
vim.keymap.set('n', '<leader>bg', '<cmd>BufferLinePick<cr>', { desc = 'Pick buffer to go to' })
vim.keymap.set('n', '<leader>bc', '<cmd>BufferLinePickClose<cr>', { desc = 'Pick buffer to close' })
