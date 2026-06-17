-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

vim.pack.add {
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = vim.version.range '*' },
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
}

local events = require 'neo-tree.events'
local function on_move(data) Snacks.rename.on_rename_file(data.source, data.destination) end

require('neo-tree').setup {
  close_if_last_window = true,
  popup_border_style = '',
  default_component_configs = {
    symlink_target = {
      enabled = true,
    },
  },
  filesystem = {
    filtered_items = {
      visible = true,
    },
    follow_current_file = { enabled = true },
    use_libuv_file_watcher = true,
    group_empty_dirs = true,
    components = {
      name = function(config, node, state)
        local result = require('neo-tree.sources.common.components').name(config, node, state)
        -- for the root node, show only the tail (directory name)
        if node:get_depth() == 1 then result.text = vim.fn.fnamemodify(node.path, ':t') end
        return result
      end,
    },
    window = {
      mappings = {
        ['U'] = 'navigate_up',
      },
    },
  },
  window = {
    mappings = {
      ['<bs>'] = 'close_node',
      ['<Tab>'] = 'open',
    },
  },
  event_handlers = {
    { event = events.FILE_MOVED, handler = on_move },
    { event = events.FILE_RENAMED, handler = on_move },
  },
}

vim.keymap.set('n', '<leader>E', '<Cmd>Neotree toggle<CR>', { desc = 'Toggle Neotree pane', silent = true })
vim.keymap.set('n', '<leader>e', '<Cmd>Neotree reveal<CR>', { desc = 'Focus Neotree pane', silent = true })
