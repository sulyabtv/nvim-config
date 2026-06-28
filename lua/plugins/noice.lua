vim.pack.add {
  'https://github.com/folke/noice.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
}

require('noice').setup {
  lsp = {
    override = {
      ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
      ['vim.lsp.util.stylize_markdown'] = true,
      ['cmp.entry.get_documentation'] = true,
    },
    progress = {
      enabled = false, -- reduce visual spam, show in lualine instead
    },
    hover = {
      enabled = true,
    },
    signature = {
      enabled = true,
    },
  },
  commands = {
    all = { view = 'popup' },
  },
  messages = {
    view_search = false,
  },
  presets = {
    long_message_to_split = true,
    inc_rename = false,
    lsp_doc_border = false,
  },
  routes = {
    {
      -- suppress error msg associated with
      -- some remote leap operations like yir{<leap>
      filter = { find = 'remote.lua.*Failed to delete autocmd' },
      opts = { skip = true },
    },
  },
}

-- message history
vim.keymap.set('n', '<leader>hm', function() require('noice').cmd 'all' end, { desc = 'Message history' })

-- LSP hover/signature scrolling
vim.keymap.set({ 'n', 'i', 's' }, '<c-f>', function()
  if not require('noice.lsp').scroll(4) then return '<c-f>' end
end, { silent = true, expr = true })
vim.keymap.set({ 'n', 'i', 's' }, '<c-b>', function()
  if not require('noice.lsp').scroll(-4) then return '<c-b>' end
end, { silent = true, expr = true })
