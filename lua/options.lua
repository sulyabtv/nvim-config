-- Enable faster startup by caching compiled Lua modules
vim.loader.enable()

-- Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- What to save when saving session/view
vim.o.sessionoptions = 'blank,buffers,curdir,folds,globals,help,tabpages,winsize,winpos,terminal'
vim.o.viewoptions = 'cursor,folds'

-- Make line numbers default in normal mode if focused
vim.o.number = true
vim.o.relativenumber = true
local grp = vim.api.nvim_create_augroup('numbertoggle', { clear = true })
vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave' }, {
  group = grp,
  callback = function()
    if vim.wo.number then vim.wo.relativenumber = true end
  end,
})
vim.api.nvim_create_autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter' }, {
  group = grp,
  callback = function()
    if vim.wo.number then vim.wo.relativenumber = false end
  end,
})

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

-- Wrap, etc.
-- Sadly, Neovim does not have soft-wrap at arbitrary columns.
-- See https://github.com/neovim/neovim/issues/4386
vim.o.wrap = true
vim.o.linebreak = true
vim.o.breakindent = true

-- Enable undo/redo changes even after closing and reopening a file
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Display whitespace
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions in buffer
vim.o.inccommand = 'nosplit'

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
vim.o.confirm = true

-- tab config
vim.o.expandtab = true -- use spaces unless overridden per filetype
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4

-- rounded borders
vim.o.winborder = 'rounded'

-- hack to hide the winseparator between explorer sidebar and editor
local function hide_layoutbox_sep()
  -- what bg does the editor use?
  local normal = vim.api.nvim_get_hl(0, { name = 'Normal' })
  local bg = normal.bg
  if not bg then return end

  vim.api.nvim_set_hl(0, 'WinSeparatorHidden', { fg = bg, bg = bg })

  for _, w in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_is_valid(w) then
      local ok, buf = pcall(vim.api.nvim_win_get_buf, w)
      if ok and vim.bo[buf].filetype == 'snacks_layout_box' then
        local wh = vim.wo[w].winhighlight
        if not wh:find('WinSeparator:WinSeparatorHidden', 1, true) then
          pcall(function() vim.wo[w].winhighlight = (wh ~= '' and wh .. ',' or '') .. 'WinSeparator:WinSeparatorHidden' end)
        end
      end
    end
  end
end

vim.api.nvim_create_autocmd({ 'WinResized', 'ColorScheme' }, {
  callback = function()
    vim.schedule(function() pcall(hide_layoutbox_sep) end)
  end,
})

-- conceal links, etc.
vim.opt.conceallevel = 2
vim.opt.concealcursor = 'nc'

-- code folding
vim.o.foldlevelstart = 1 -- start with all but outermost fold closed

-- remember folds when switching between buffers
local fold_group = vim.api.nvim_create_augroup('remember-folds', { clear = true })

vim.api.nvim_create_autocmd({ 'BufWinLeave' }, {
  group = fold_group,
  pattern = '?*', -- only real, named buffers
  callback = function()
    if vim.bo.buftype == '' then -- skip special buffers (help, terminal, quickfix, etc.)
      pcall(vim.cmd.mkview)
    end
  end,
})

vim.api.nvim_create_autocmd({ 'BufWinEnter' }, {
  group = fold_group,
  pattern = '?*',
  callback = function()
    if vim.bo.buftype == '' then pcall(vim.cmd.loadview) end
  end,
})
