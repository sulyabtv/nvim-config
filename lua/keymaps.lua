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
vim.keymap.set('n', '<leader>tS', function() vim.o.laststatus = vim.o.laststatus == 0 and 3 or 0 end, { desc = 'Toggle statusline' })

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
-- A paragraph is a run of non-blank lines.
-- `}` / `{` jump to the first non-blank character of the next / previous paragraph start,
-- `g}` / `g{` to the last character of the next / previous paragraph end.
-- Closed folds count as one line.

local function is_blank(row) return vim.fn.getline(row):match '^%s*$' ~= nil end

local function fold_visible_row(row)
  local fold_start = vim.fn.foldclosed(row)
  return fold_start == -1 and row or fold_start
end

-- The next visible row in `direction` (1 or -1), treating a closed fold as a
-- single row. Returns `row` itself at the buffer boundary.
local function advance(row, direction)
  local total = vim.fn.line '$'
  local next_row = math.max(1, math.min(row + direction, total))
  local fold_start = vim.fn.foldclosed(next_row)
  if fold_start == -1 then return next_row end -- not in a fold
  if fold_start ~= row then return fold_start end -- a different fold: land on its first line
  -- next_row is inside the fold we are already on: skip past it
  local fold_end = vim.fn.foldclosedend(next_row)
  if fold_end >= total then return row end
  return fold_end + 1
end

local function is_paragraph_start(row)
  if is_blank(row) then return false end
  local prev = advance(row, -1)
  return prev == row or is_blank(prev)
end

local function is_paragraph_end(row)
  if is_blank(row) then return false end
  local next = advance(row, 1)
  return next == row or is_blank(next)
end

-- Move at least one row in `direction`, then keep going until `is_boundary`.
-- Returns the row reached (the buffer boundary if no boundary was found).
local function find_boundary(row, direction, is_boundary)
  local next = advance(row, direction)
  while next ~= row do
    row = next
    if is_boundary(row) then return row end
    next = advance(row, direction)
  end
  return row
end

local function paragraph_motion(direction, is_boundary, to_line_end)
  return function()
    local operator_pending = vim.api.nvim_get_mode().mode:sub(1, 2) == 'no'
    local row = fold_visible_row(vim.fn.line '.')
    for _ = 1, vim.v.count1 do
      local next = find_boundary(row, direction, is_boundary)
      if next == row then break end
      row = next
    end

    vim.cmd "normal! m'" -- jumplist entry
    if to_line_end and operator_pending and direction < 0 then
      -- Backward with an operator: exclusive motion ending just after the
      -- paragraph (`dg{` deletes everything between the previous paragraph
      -- and the cursor, keeping that paragraph intact).
      vim.api.nvim_win_set_cursor(0, { advance(row, 1), 0 })
    elseif to_line_end then
      -- Forward with an operator: inclusive, so `dg}` deletes through the end
      -- of the paragraph, like `d$` does for a line.
      if operator_pending then vim.cmd 'normal! v' end
      local line = vim.fn.getline(row)
      local col = #line == 0 and 0 or vim.fn.byteidx(line, vim.fn.strchars(line) - 1)
      vim.api.nvim_win_set_cursor(0, { row, col })
    else
      vim.api.nvim_win_set_cursor(0, { row, 0 })
      -- With an operator stay in column 0 so Vim's exclusive-linewise rules
      -- apply (`d}` from the start of a line deletes whole lines). See
      -- `:help exclusive-linewise`.
      if not operator_pending then vim.cmd 'normal! ^' end
    end
  end
end

local modes = { 'n', 'x', 'o' }
vim.keymap.set(modes, '}', paragraph_motion(1, is_paragraph_start, false), { desc = 'Next paragraph start' })
vim.keymap.set(modes, '{', paragraph_motion(-1, is_paragraph_start, false), { desc = 'Prev paragraph start' })
vim.keymap.set(modes, 'g}', paragraph_motion(1, is_paragraph_end, true), { desc = 'Next paragraph end' })
vim.keymap.set(modes, 'g{', paragraph_motion(-1, is_paragraph_end, true), { desc = 'Prev paragraph end' })

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
vim.keymap.set('i', '<M-BS>', '<C-g>u<C-w>', { desc = 'Delete word backward' })

-- Add undo breakpoints at punctuation in insert mode
for _, ch in ipairs { ',', '.', '!', '?', ';', ':' } do
  vim.keymap.set('i', ch, ch .. '<C-g>u')
end

-- Diagnostics
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic quickfix list' })
vim.keymap.set('n', '<leader>td', function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end, { desc = 'Toggle diagnostics' })

-- Consistent indentation in different modes
vim.keymap.set('n', '<C-t>', 'i<C-t><Esc>', { desc = 'Indent line right' })
vim.keymap.set('n', '<C-S-t>', 'i<C-d><Esc>', { desc = 'Indent line left' })
vim.keymap.set('i', '<C-S-t>', '<C-d>', { desc = 'Indent line left' })
vim.keymap.set('x', '<C-t>', '>gv', { desc = 'Indent selection right' })
vim.keymap.set('x', '<C-S-t>', '<gv', { desc = 'Indent selection left' })
