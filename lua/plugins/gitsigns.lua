local function gh(repo) return 'https://github.com/' .. repo end

-- Here is a more advanced configuration example that passes options to `gitsigns.nvim`
--
-- See `:help gitsigns` to understand what each configuration key does.
-- Adds git related signs to the gutter, as well as utilities for managing changes
vim.pack.add { gh 'lewis6991/gitsigns.nvim' }
local gitsigns = require 'gitsigns'
gitsigns.setup {
  signs = {
    add = { text = '+' }, ---@diagnostic disable-line: missing-fields
    change = { text = '~' }, ---@diagnostic disable-line: missing-fields
    delete = { text = '_' }, ---@diagnostic disable-line: missing-fields
    topdelete = { text = '‾' }, ---@diagnostic disable-line: missing-fields
    changedelete = { text = '~' }, ---@diagnostic disable-line: missing-fields
  },
  current_line_blame = true,
  on_attach = function(bufnr)
    -- Navigation
    vim.keymap.set('n', ']g', function()
      if vim.wo.diff then
        vim.cmd.normal { ']c', bang = true }
      else
        gitsigns.nav_hunk 'next'
      end
    end, { desc = 'Jump to next git change', buf = bufnr })

    vim.keymap.set('n', '[g', function()
      if vim.wo.diff then
        vim.cmd.normal { '[c', bang = true }
      else
        gitsigns.nav_hunk 'prev'
      end
    end, { desc = 'Jump to previous git change', buf = bufnr })

    -- Visual mode actions
    vim.keymap.set('v', '<leader>ga', function() gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = 'git stage hunk', buf = bufnr })
    vim.keymap.set('v', '<leader>gr', function() gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = 'git reset hunk', buf = bufnr })

    -- Normal mode actions
    vim.keymap.set('n', '<leader>ga', gitsigns.stage_hunk, { desc = 'git stage hunk', buf = bufnr })
    vim.keymap.set('n', '<leader>gr', gitsigns.reset_hunk, { desc = 'git reset hunk', buf = bufnr })
    vim.keymap.set('n', '<leader>gp', gitsigns.preview_hunk, { desc = 'git preview hunk', buf = bufnr })
    vim.keymap.set('n', '<leader>gA', gitsigns.stage_buffer, { desc = 'git stage buffer', buf = bufnr })
    vim.keymap.set('n', '<leader>gR', gitsigns.reset_buffer, { desc = 'git reset buffer', buf = bufnr })
    vim.keymap.set('n', '<leader>gb', function() gitsigns.blame() end, { desc = 'git blame', buf = bufnr })

    -- Toggles
    vim.keymap.set('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = 'Toggle git blame line', buf = bufnr })
    vim.keymap.set('n', '<leader>tw', gitsigns.toggle_word_diff, { desc = 'Toggle git word diff', buf = bufnr })
    vim.keymap.set('n', '<leader>tm', gitsigns.toggle_signs, { desc = 'Toggle margin line change indicator', buf = bufnr })

    -- Text object
    vim.keymap.set({ 'o', 'x' }, 'ih', gitsigns.select_hunk, { desc = 'text object inside hunk', buf = bufnr })
  end,
}
