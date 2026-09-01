vim.pack.add { { src = 'https://codeberg.org/andyg/leap.nvim' } }

local leap = require 'leap'
-- disable autojumping to the first match
leap.opts.safe_labels = ''
-- display labels after the match instead of beginning
leap.opts.offset_labels = true
-- "reduce visual noise"
leap.opts.preview = function(ch0, ch1, ch2) return not (ch1:match '%s' or (ch0:match '%a' and ch1:match '%a' and ch2:match '%a')) end

-- leap to another spot in the same window
vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap)')

-- leap to a different window
vim.keymap.set('n', 'S', '<Plug>(leap-from-window)')

-- remote operations
-- gs{leap}$y, dgs{leap}$ etc.
vim.keymap.set({ 'n', 'o' }, 'gs', '<Plug>(leap-remote)')

-- linewise remote operations
-- yR{leap} (one line), d10R{leap} (10 lines), etc.
vim.keymap.set({ 'o' }, 'R', '<Plug>(leap-remote-line)')

-- These commands expect another character as input before leaping, and
-- select the given text object at the destination (`yarp{leap}`).
vim.keymap.set({ 'x', 'o' }, 'ar', '<Plug>(leap-remote-text-object)')
vim.keymap.set({ 'x', 'o' }, 'ir', '<Plug>(leap-remote-inner-text-object)')

-- A helper function making it easier to set "clever-f" behavior
-- (using f/F or t/T instead of ;/, - see the plugin clever-f.vim).
local function ft(kwargs)
  require('leap').leap(vim.tbl_deep_extend('keep', kwargs, {
    inputlen = 1,
    inclusive = true,
    opts = {
      -- Force autojump.
      labels = '',
      -- Match the modes where you don't need labels (`:h mode()`).
      safe_labels = vim.fn.mode(1):match 'no?' and '' or nil,
    },
  }))
end
local clever = require('leap.user').with_traversal_keys
local clever_f, clever_t = clever('f', 'F'), clever('t', 'T')

vim.keymap.set({ 'n', 'x', 'o' }, 'f', function() ft { opts = clever_f } end)
vim.keymap.set({ 'n', 'x', 'o' }, 'F', function() ft { backward = true, opts = clever_f } end)
vim.keymap.set({ 'n', 'x', 'o' }, 't', function() ft { offset = -1, opts = clever_t } end)

vim.keymap.set({ 'n', 'x', 'o' }, 'T', function() ft { backward = true, offset = 1, opts = clever_t } end)
