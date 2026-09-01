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

-- M-/ to toggle comment
vim.keymap.set({ 'n', 'v' }, '<M-/>', function() vim.cmd 'normal gcc' end, { desc = 'Toggle comment' })
vim.keymap.set({ 'i' }, '<M-/>', function() require('mini.comment').toggle_lines(vim.fn.line '.', vim.fn.line '.') end, { desc = 'Toggle comment' })

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

-- Toggle spellcheck
vim.keymap.set('n', '<leader>ts', function() vim.wo.spell = not vim.wo.spell end, { desc = 'Toggle spellcheck' })

-- Copy whole file to clipboard
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

-- open window splits
vim.keymap.set('n', '<leader>-', '<Cmd>split<CR>', { desc = 'New horizontal split' })
vim.keymap.set('n', '<leader>|', '<Cmd>vsplit<CR>', { desc = 'New vertical split' })

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

local function fold_visible_row(row)
  local fold_start = vim.fn.foldclosed(row)
  return fold_start == -1 and row or fold_start
end

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
  local row = fold_visible_row(vim.fn.line '.')

  -- if we are at the end of a paragraph move down one line
  if row < total and is_paragraph_end(row, total) then row = advance(row, 1) end
  -- keep moving down until we reach the end of a paragraph
  while row < total and (vim.fn.getline(row):match '^%s*$' or not vim.fn.getline(row + 1):match '^%s*$') do
    local before = row
    row = advance(row, 1)
    if row == before then break end
  end

  vim.api.nvim_win_set_cursor(0, { row, 0 })
  vim.cmd 'normal! ^'
end

local function next_paragraph_start()
  local total = vim.fn.line '$'
  local row = fold_visible_row(vim.fn.line '.')

  -- if we are at the beginning of a paragraph move down one line
  if row < total and is_paragraph_start(row) then row = advance(row, 1) end
  -- keep moving down until we reach the beginning of a paragraph
  while row < total and (vim.fn.getline(row):match '^%s*$' or (row > 1 and not vim.fn.getline(row - 1):match '^%s*$')) do
    local before = row
    row = advance(row, 1)
    if row == before then break end
  end

  vim.api.nvim_win_set_cursor(0, { row, 0 })
  vim.cmd 'normal! ^'
end

local function prev_paragraph_end()
  local total = vim.fn.line '$'
  local row = fold_visible_row(vim.fn.line '.')

  -- if we are at the end of a paragraph move up one line
  if row > 1 and is_paragraph_end(row, total) then row = advance(row, -1) end
  -- keep moving up until we reach the end of a paragraph
  while row > 1 and (vim.fn.getline(row):match '^%s*$' or (row < total and not vim.fn.getline(row + 1):match '^%s*$')) do
    local before = row
    row = advance(row, -1)
    if row == before then break end
  end

  vim.api.nvim_win_set_cursor(0, { row, 0 })
  vim.cmd 'normal! ^'
end

local function prev_paragraph_start()
  local row = fold_visible_row(vim.fn.line '.')

  -- if we are at the start of a paragraph move up one line
  if row > 1 and is_paragraph_start(row) then row = advance(row, -1) end
  -- keep moving up until we reach the start of a paragraph
  while row > 1 and (vim.fn.getline(row):match '^%s*$' or not vim.fn.getline(row - 1):match '^%s*$') do
    local before = row
    row = advance(row, -1)
    if row == before then break end
  end

  vim.api.nvim_win_set_cursor(0, { row, 0 })
  vim.cmd 'normal! ^'
end

vim.keymap.set('n', '}', next_paragraph_start, { desc = 'Next paragraph start' })
vim.keymap.set('n', '{', prev_paragraph_start, { desc = 'Prev paragraph start' })
vim.keymap.set('n', 'g}', next_paragraph_end, { desc = 'Next paragraph end' })
vim.keymap.set('n', 'g{', prev_paragraph_end, { desc = 'Prev paragraph end' })

-- Move around faster using M-<Up/Down/Left/Right>
vim.keymap.set({ 'n', 'i', 'x' }, '<M-Right>', function()
  local line_before = vim.fn.line '.'
  local end_col = vim.fn.col { line_before, '$' }
  vim.cmd 'normal! w'
  if vim.fn.line '.' ~= line_before then
    vim.fn.cursor(line_before, end_col) -- don't move past end of line
  end
end, { desc = 'Move one word right' })

vim.keymap.set({ 'n', 'i', 'x' }, '<M-Left>', function()
  local line_before = vim.fn.line '.'
  vim.cmd 'normal! b'
  if vim.fn.line '.' ~= line_before then
    vim.fn.cursor(line_before, 1) -- don't move past beginning of line
  end
end, { desc = 'Move one word left' })

vim.keymap.set({ 'n', 'i', 'x' }, '<M-Up>', function()
  local n = math.max(1, math.floor(vim.api.nvim_win_get_height(0) / 5))
  vim.cmd('normal! ' .. n .. 'gk')
end, { desc = 'Jump up few lines' })

vim.keymap.set({ 'n', 'i', 'x' }, '<M-Down>', function()
  local n = math.max(1, math.floor(vim.api.nvim_win_get_height(0) / 5))
  vim.cmd('normal! ' .. n .. 'gj')
end, { desc = 'Jump down few lines' })

-- Navigate display lines using arrow keys
vim.keymap.set({ 'n', 'x' }, '<Down>', 'gj', { desc = 'Down' })
vim.keymap.set({ 'n', 'x' }, '<Up>', 'gk', { desc = 'Up' })

-- M-BS to delete word in insert mode
vim.keymap.set('i', '<M-BS>', '<C-w>', { desc = 'Delete word backward' })

-- Diagnostics
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic quickfix list' })
vim.keymap.set('n', '<leader>td', function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end, { desc = 'Toggle diagnostics' })

-- Consistent indentation in different modes
vim.keymap.set('n', '<C-t>', 'i<C-t><Esc>', { desc = 'Indent line right' })
vim.keymap.set('n', '<C-S-t>', 'i<C-d><Esc>', { desc = 'Indent line left' })
vim.keymap.set('i', '<C-S-t>', '<C-d>', { desc = 'Indent line left' })
vim.keymap.set('x', '<C-t>', '>gv', { desc = 'Indent selection right' })
vim.keymap.set('x', '<C-S-t>', '<gv', { desc = 'Indent selection left' })
