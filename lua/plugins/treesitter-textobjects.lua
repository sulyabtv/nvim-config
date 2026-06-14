vim.pack.add {
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects', version = 'main' },
}

require('nvim-treesitter-textobjects').setup {
  select = {
    lookahead = true,
  },
}

local select = require 'nvim-treesitter-textobjects.select'
local function sel(key, query, desc)
  vim.keymap.set({ 'x', 'o' }, key, function() select.select_textobject(query, 'textobjects') end, { desc = desc })
end

sel('af', '@function.outer', 'a function')
sel('if', '@function.inner', 'inner function')
sel('ac', '@class.outer', 'a class')
sel('ic', '@class.inner', 'inner class')
sel('aa', '@parameter.outer', 'a parameter')
sel('ia', '@parameter.inner', 'inner parameter')
sel('a?', '@conditional.outer', 'a conditional')
sel('i?', '@conditional.inner', 'inner conditional')
sel('al', '@loop.outer', 'a loop')
sel('il', '@loop.inner', 'inner loop')

-- movement between functions/classes
local move = require 'nvim-treesitter-textobjects.move'
vim.keymap.set({ 'n', 'x', 'o' }, ']f', function() move.goto_next_start('@function.outer', 'textobjects') end, { desc = 'Next function' })
vim.keymap.set({ 'n', 'x', 'o' }, '[f', function() move.goto_previous_start('@function.outer', 'textobjects') end, { desc = 'Prev function' })
vim.keymap.set({ 'n', 'x', 'o' }, ']c', function() move.goto_next_start('@class.outer', 'textobjects') end, { desc = 'Next class' })
vim.keymap.set({ 'n', 'x', 'o' }, '[c', function() move.goto_previous_start('@class.outer', 'textobjects') end, { desc = 'Prev class' })
