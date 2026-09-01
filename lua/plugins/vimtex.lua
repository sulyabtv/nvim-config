-- let treesitter win over vimtex
vim.g.vimtex_syntax_enabled = 0
vim.g.vimtex_syntax_conceal_disable = 1
-- do not automatically open the quickfix window
vim.g.vimtex_quickfix_mode = 0

if vim.env.SSH_CONNECTION ~= nil then
  -- Use http server + firefox :')
  vim.g.vimtex_view_enabled = 0
elseif vim.fn.has 'mac' == 1 then
  vim.g.vimtex_view_method = 'skim'
else
  vim.g.vimtex_view_method = 'zathura_simple'
end

vim.pack.add { { src = 'https://github.com/lervag/vimtex' } }
