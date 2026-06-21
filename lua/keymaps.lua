-- [[ Basic Keymaps ]]

-- fix C-i to work with iTerm2
vim.keymap.set('n', '<C-i>', '<C-i>', { desc = 'Jumplist forward' })

-- Ctrl+S saves in normal, insert and visual modes
vim.keymap.set({ 'n', 'i', 'v' }, '<C-s>', '<cmd>w<cr><Esc>', { desc = 'Save and exit to normal mode' })

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- -- fancier: make Esc do Esc-y things
-- vim.keymap.set('n', '<Esc>', function()
--   -- no floats => clear search highlight if active
--   if vim.v.hlsearch == 1 then
--     vim.cmd 'noh'
--     return
--   end
--   -- ugly hack to not exit zenmode accidentally
--   -- pre-scan: find zenmode-bg, mark its window id and id+1
--   local skip = {}
--   for _, win in ipairs(vim.api.nvim_list_wins()) do
--     if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == 'zenmode-bg' then
--       skip[win] = true
--       skip[win + 1] = true
--     end
--   end
--   -- close the first float that isn't marked
--   for _, win in ipairs(vim.api.nvim_list_wins()) do
--     if not skip[win] then
--       if vim.api.nvim_win_get_config(win).relative ~= '' then
--         vim.api.nvim_win_close(win, false)
--         return
--       end
--     end
--   end
-- end, { desc = 'Close float or clear highlight' })

-- Keep selection after indenting in visual mode
vim.keymap.set('v', '<', '<gv', { desc = 'Indent left' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent right' })

-- C-/ to toggle comment
vim.keymap.set({ 'n', 'i', 'v' }, '<C-/>', function() vim.cmd 'normal gcc' end, { desc = 'Toggle comment' })

-- Diagnostic Config & Keymaps
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },

  -- Can switch between these as you prefer
  virtual_text = true, -- Text shows up at the end of the line
  virtual_lines = false, -- Text shows up underneath the line, with virtual lines

  -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
  jump = {
    on_jump = function(_, bufnr)
      vim.diagnostic.open_float {
        bufnr = bufnr,
        scope = 'cursor',
        focus = false,
      }
    end,
  },
}
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Double Esc to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

--  Use CTRL+<hjkl> to switch between windows
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Use CTRL+p to switch to the previous window
vim.keymap.set('n', '<C-p>', '<C-w><C-p>', { desc = 'Move focus to the last focused window' })

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- toggle tmux's status bar to reduce distraction
vim.keymap.set('n', '<leader>tx', function()
  if vim.env.TMUX then
    vim.fn.system [[tmux set status #{?status,off,on}]]
  else
    vim.notify('Not in a tmux session', vim.log.levels.WARN)
  end
end, { desc = 'Toggle tmux status bar' })

vim.keymap.set('n', '<C-c>', '<cmd>%y+<cr>', { desc = 'Copy whole file to clipboard' })

-- shortcut to insert today's date
vim.keymap.set('n', '<leader>md', function()
  local date = tostring(os.date '%Y-%m-%d')
  vim.api.nvim_put({ date }, 'c', true, true)
end, { desc = 'Insert current date' })

-- vim pack shortcuts
vim.keymap.set('n', '<leader>pu', function() vim.pack.update(nil, { force = true }) end, { desc = 'Pack: update plugins' })
vim.keymap.set('n', '<leader>pl', function() vim.pack.update(nil, { offline = true }) end, { desc = 'Pack: list installed plugins' })
vim.keymap.set('n', '<leader>pd', function()
  local names = {}
  for _, p in ipairs(vim.pack.get()) do
    if not p.active then names[#names + 1] = p.spec.name end
  end
  table.sort(names)

  if #names == 0 then
    vim.notify('No inactive plugins to delete.', vim.log.levels.INFO)
    return
  end

  vim.ui.select(names, { prompt = 'Delete plugin:' }, function(choice)
    if not choice then return end
    if vim.fn.confirm('Delete ' .. choice .. '?', '&Yes\n&No', 2) == 1 then
      local ok, err = pcall(vim.pack.del, { choice })
      if not ok then vim.notify('Could not delete ' .. choice .. ': ' .. tostring(err), vim.log.levels.ERROR) end
    end
  end)
end, { desc = 'Delete an inactive plugin' })
