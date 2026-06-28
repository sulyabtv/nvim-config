-- Enable faster startup by caching compiled Lua modules
vim.loader.enable()

-- Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

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
vim.o.wrap = true
vim.o.linebreak = true
vim.o.breakindent = true
vim.fn.matchadd('ErrorMsg', '\\%100v.\\+') -- use scary color if line goes beyond 99 chars

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

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Always keep the current line centered
vim.o.scrolloff = 999

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
vim.o.confirm = true

-- tab size
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4

-- code folding
vim.o.foldlevelstart = 99 -- start with everything open

-- rounded borders
vim.o.winborder = 'rounded'

-- hide tmux statusbar on entry, put it back on exit
local function tmux_status(state)
  if not vim.env.TMUX then return end
  vim.fn.system { 'tmux', 'set-option', 'status', state }
end

local tmuxgrp = vim.api.nvim_create_augroup('TmuxStatusToggle', { clear = true })

vim.api.nvim_create_autocmd({ 'VimEnter', 'VimResume' }, {
  group = tmuxgrp,
  callback = function() tmux_status 'off' end,
})

vim.api.nvim_create_autocmd({ 'VimLeavePre', 'VimSuspend' }, {
  group = tmuxgrp,
  callback = function() tmux_status 'on' end,
})
