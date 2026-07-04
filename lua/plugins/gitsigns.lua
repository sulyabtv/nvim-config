local function gh(repo) return 'https://github.com/' .. repo end

-- Here is a more advanced configuration example that passes options to `gitsigns.nvim`
--
-- See `:help gitsigns` to understand what each configuration key does.
-- Adds git related signs to the gutter, as well as utilities for managing changes
vim.pack.add { gh 'lewis6991/gitsigns.nvim' }
require('gitsigns').setup {
  signs = {
    add = { text = '+' }, ---@diagnostic disable-line: missing-fields
    change = { text = '~' }, ---@diagnostic disable-line: missing-fields
    delete = { text = '_' }, ---@diagnostic disable-line: missing-fields
    topdelete = { text = '‾' }, ---@diagnostic disable-line: missing-fields
    changedelete = { text = '~' }, ---@diagnostic disable-line: missing-fields
  },
  current_line_blame = true,
  on_attach = function(bufnr)
    local gitsigns = require 'gitsigns'

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']g', function()
      if vim.wo.diff then
        vim.cmd.normal { ']c', bang = true }
      else
        gitsigns.nav_hunk 'next'
      end
    end, { desc = 'Jump to next git change' })

    map('n', '[g', function()
      if vim.wo.diff then
        vim.cmd.normal { '[c', bang = true }
      else
        gitsigns.nav_hunk 'prev'
      end
    end, { desc = 'Jump to previous git change' })

    -- Actions
    -- visual mode
    map('v', '<leader>ga', function() gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = 'git stage hunk' })
    map('v', '<leader>gr', function() gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = 'git reset hunk' })
    -- normal mode
    map('n', '<leader>ga', gitsigns.stage_hunk, { desc = 'git stage hunk' })
    map('n', '<leader>gr', gitsigns.reset_hunk, { desc = 'git reset hunk' })
    map('n', '<leader>gp', gitsigns.preview_hunk, { desc = 'git preview hunk' })
    map('n', '<leader>gA', gitsigns.stage_buffer, { desc = 'git stage buffer' })
    map('n', '<leader>gR', gitsigns.reset_buffer, { desc = 'git reset buffer' })
    map('n', '<leader>gb', function() gitsigns.blame() end, { desc = 'git blame' })
    -- Toggles
    map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = 'Toggle git blame line' })
    map('n', '<leader>tw', gitsigns.toggle_word_diff, { desc = 'Toggle git word diff' })
    map('n', '<leader>tm', gitsigns.toggle_signs, { desc = 'Toggle margin line change indicator' })

    -- Text object
    map({ 'o', 'x' }, 'ih', gitsigns.select_hunk)
  end,
}
