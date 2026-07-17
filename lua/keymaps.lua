-- [[ Basic Keymaps ]]

-- fix C-i to work with iTerm2
vim.keymap.set('n', '<C-i>', '<C-i>', { desc = 'Jumplist forward' })

-- Ctrl+S saves in normal, insert and visual modes
vim.keymap.set({ 'n', 'i', 'v' }, '<C-s>', '<cmd>w<cr><Esc>', { desc = 'Save and exit to normal mode' })

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

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

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- toggle tmux status bar
vim.keymap.set('n', '<leader>tx', function()
  if vim.env.TMUX then
    vim.fn.system [[tmux set status #{?status,off,on}]]
  else
    vim.notify('Not in a tmux session', vim.log.levels.WARN)
  end
end, { desc = 'Toggle tmux status bar' })

-- toggle neovim statusline
vim.keymap.set('n', '<leader>ts', function() vim.o.laststatus = vim.o.laststatus == 0 and 3 or 0 end, { desc = 'Toggle statusline' })

vim.keymap.set('n', '<C-c>', '<cmd>%y+<cr>', { desc = 'Copy whole file to clipboard' })

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

-- yank absolute path of current file
vim.keymap.set('n', '<leader>yp', function()
  local p = vim.fn.expand '%:p'
  vim.fn.setreg('+', p)
  vim.notify(p)
end, { desc = 'Yank absolute path' })

-- yank path relative to cwd
vim.keymap.set('n', '<leader>yr', function()
  local p = vim.fn.expand '%:.'
  vim.fn.setreg('+', p)
  vim.notify(p)
end, { desc = 'Yank relative path' })

-- close current tabpage
vim.keymap.set('n', '<leader>tc', '<Cmd>tabclose<CR>', { desc = 'Close tab' })

-- Tab to toggle fold
---@diagnostic disable-next-line: param-type-mismatch
vim.keymap.set('n', '<Tab>', function() pcall(vim.cmd, 'normal! za') end, { desc = 'Toggle fold' })

local function next_closed_fold(direction)
  local cmd = (direction == 'forward') and 'zj' or 'zk'
  local start_line, start_col = vim.fn.line '.', vim.fn.col '.'
  for _ = 1, 1000 do
    local before = vim.fn.line '.'
    vim.cmd('normal! ' .. cmd)
    local after = vim.fn.line '.'
    if before == after then
      vim.fn.cursor(start_line, start_col)
      vim.notify('No more closed folds', vim.log.levels.INFO)
      return
    end
    if vim.fn.foldclosed '.' ~= -1 then return end
  end
end

vim.keymap.set('n', ']Z', function() next_closed_fold 'forward' end, { desc = 'Next closed fold' })
vim.keymap.set('n', '[Z', function() next_closed_fold 'backward' end, { desc = 'Prev closed fold' })
