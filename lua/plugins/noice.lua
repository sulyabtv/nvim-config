vim.pack.add {
  'https://github.com/folke/noice.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
}

-- Hack to not let noice swallow duplicate notifications
local state = require 'noice.ui.state'
local original_skip = state.skip
---@diagnostic disable-next-line: duplicate-set-field
state.skip = function(event, kind, ...)
  if event == 'msg_show' then
    state.set(event, kind, ...)
    return false
  end
  return original_skip(event, kind, ...)
end

require('noice').setup {
  lsp = {
    progress = { enabled = false },
    hover = { enabled = false },
    signature = { enabled = false },
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
