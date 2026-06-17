vim.g.tex_flavor = 'latex' -- treat .tex as latex

if vim.env.SSH_CONNECTION ~= nil then
  -- Use http server + firefox :')
  vim.g.vimtex_view_enabled = 0
elseif vim.fn.has 'mac' == 1 then
  vim.g.vimtex_view_method = 'skim'
else
  vim.g.vimtex_view_method = 'zathura_simple'
end

vim.pack.add { { src = 'https://github.com/lervag/vimtex' } }
