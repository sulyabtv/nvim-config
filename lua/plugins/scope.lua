vim.pack.add { 'https://github.com/tiagovla/scope.nvim' }

require('scope').setup {}

local function tab_and_explorer(cmd, times)
  for _ = 1, times or 1 do
    vim.cmd(cmd)
  end
  local explorer = Snacks.picker.get({ source = 'explorer' })[1]
  if explorer == nil then Snacks.picker.explorer { focus = false } end
end

vim.keymap.set('n', '<leader>nt', function() tab_and_explorer 'tabnew' end, { desc = 'New tab' })
vim.keymap.set('n', '<leader>mt', function() tab_and_explorer 'ScopeMoveBuf' end, { desc = 'Move buffer to tab' })
vim.keymap.set('n', ']t', function() tab_and_explorer('tabnext', vim.v.count1) end, { desc = 'Next tab' })
vim.keymap.set('n', '[t', function() tab_and_explorer('tabprevious', vim.v.count1) end, { desc = 'Prev tab' })
