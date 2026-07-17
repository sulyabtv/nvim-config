vim.pack.add { 'https://github.com/tiagovla/scope.nvim' }

require('scope').setup {}

local function tab_and_explorer(cmd)
  vim.cmd(cmd)
  local explorer = Snacks.picker.get({ source = 'explorer' })[1]
  if explorer == nil then Snacks.picker.explorer { focus = false } end
end

vim.keymap.set('n', '<leader>nt', function() tab_and_explorer 'tabnew' end, { desc = 'New tab' })
vim.keymap.set('n', ']t', function() tab_and_explorer 'tabnext' end, { desc = 'Next tab' })
vim.keymap.set('n', '[t', function() tab_and_explorer 'tabprevious' end, { desc = 'Prev tab' })
