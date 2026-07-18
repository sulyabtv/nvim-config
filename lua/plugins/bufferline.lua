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
        -- no tabs on the snacks explorer window
        filetype = 'snacks_layout_box',
      },
    },
  },
}

-- buffer move
vim.keymap.set('n', '<leader>]', '<cmd>BufferLineMoveNext<cr>', { desc = 'Swap with next buffer' })
vim.keymap.set('n', '<leader>[', '<cmd>BufferLineMovePrev<cr>', { desc = 'Swap with prev buffer' })

-- buffer navigation
vim.keymap.set('n', ']b', '<cmd>BufferLineCycleNext<cr>', { desc = 'Next buffer' })
vim.keymap.set('n', '[b', '<cmd>BufferLineCyclePrev<cr>', { desc = 'Prev buffer' })
vim.keymap.set('n', '<leader>b', '<cmd>BufferLinePick<cr>', { desc = 'Pick buffer' })
