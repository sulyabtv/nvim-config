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

-- close current tabpage/window
vim.keymap.set('n', '<leader>xt', '<Cmd>tabclose<CR>', { desc = 'Close current tab' })
vim.keymap.set('n', '<leader>xw', '<Cmd>close<CR>', { desc = 'Close current window' })
vim.keymap.set('n', '<leader>xn', '<Cmd>qa<CR>', { desc = 'Close Neovim' })

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

-- (Hopefully) better semantics for { / }
local function is_paragraph_end(row, total) return not vim.fn.getline(row):match '^%s*$' and (row == total or vim.fn.getline(row + 1):match '^%s*$') end

local function is_paragraph_start(row) return not vim.fn.getline(row):match '^%s*$' and (row == 1 or vim.fn.getline(row - 1):match '^%s*$') end

local function advance(row, direction)
  local total = vim.fn.line '$'
  local function clamp(n) return math.max(1, math.min(n, total)) end

  local next_row = clamp(row + direction)
  local fold_start = vim.fn.foldclosed(next_row)

  if fold_start == -1 then return next_row end -- not in a fold

  if row == fold_start then
    if direction > 0 then
      local fold_end = vim.fn.foldclosedend(next_row)
      if fold_end == total then return row end -- do not move if the fold covers the last line
      return fold_end + 1
    else
      if fold_start == 1 then return row end -- do not move if the fold covers the first line
      return fold_start - 1
    end
  end

  return fold_start
end

local function next_paragraph_end()
  local total = vim.fn.line '$'
  local row = vim.fn.line '.'

  -- if we are at the end of a paragraph move down one line
  if row < total and is_paragraph_end(row, total) then row = advance(row, 1) end
  -- keep moving down until we reach the end of a paragraph
  while row < total and (vim.fn.getline(row):match '^%s*$' or not vim.fn.getline(row + 1):match '^%s*$') do
    row = advance(row, 1)
  end

  vim.api.nvim_win_set_cursor(0, { row, 0 })
  vim.cmd 'normal! ^'
end

local function next_paragraph_start()
  local total = vim.fn.line '$'
  local row = vim.fn.line '.'

  -- if we are at the beginning of a paragraph move down one line
  if row < total and is_paragraph_start(row) then row = advance(row, 1) end
  -- keep moving down until we reach the beginning of a paragraph
  while row < total and (vim.fn.getline(row):match '^%s*$' or (row > 1 and not vim.fn.getline(row - 1):match '^%s*$')) do
    row = advance(row, 1)
  end

  vim.api.nvim_win_set_cursor(0, { row, 0 })
  vim.cmd 'normal! ^'
end

local function prev_paragraph_end()
  local total = vim.fn.line '$'
  local row = vim.fn.line '.'

  -- if we are at the end of a paragraph move up one line
  if row > 1 and is_paragraph_end(row, total) then row = advance(row, -1) end
  -- keep moving up until we reach the end of a paragraph
  while row > 1 and (vim.fn.getline(row):match '^%s*$' or (row < total and not vim.fn.getline(row + 1):match '^%s*$')) do
    row = advance(row, -1)
  end

  vim.api.nvim_win_set_cursor(0, { row, 0 })
  vim.cmd 'normal! ^'
end

local function prev_paragraph_start()
  local row = vim.fn.line '.'

  -- if we are at the start of a paragraph move up one line
  if row > 1 and is_paragraph_start(row) then row = advance(row, -1) end
  -- keep moving up until we reach the start of a paragraph
  while row > 1 and (vim.fn.getline(row):match '^%s*$' or not vim.fn.getline(row - 1):match '^%s*$') do
    row = advance(row, -1)
  end

  vim.api.nvim_win_set_cursor(0, { row, 0 })
  vim.cmd 'normal! ^'
end

vim.keymap.set({ 'n', 'x', 'o' }, '}', next_paragraph_start, { desc = 'Next paragraph start' })
vim.keymap.set({ 'n', 'x', 'o' }, '{', prev_paragraph_start, { desc = 'Prev paragraph start' })
vim.keymap.set({ 'n', 'x', 'o' }, 'g}', next_paragraph_end, { desc = 'Next paragraph end' })
vim.keymap.set({ 'n', 'x', 'o' }, 'g{', prev_paragraph_end, { desc = 'Prev paragraph end' })

-- Move around faster in insert mode
vim.keymap.set('i', '<M-Right>', '<C-Right>', { desc = 'Move one word right' })
vim.keymap.set('i', '<M-Left>', '<C-Left>', { desc = 'Move one word left' })
