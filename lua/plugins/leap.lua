vim.pack.add { { src = 'https://codeberg.org/andyg/leap.nvim' } }

require('leap').opts = {
  -- disable autojumping on the first match
  safe_labels = '',
  -- "reduce visual noise"
  preview = function(ch0, ch1, ch2) return not (ch1:match '%s' or (ch0:match '%a' and ch1:match '%a' and ch2:match '%a')) end,
}

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
