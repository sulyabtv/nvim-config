vim.g.tex_flavor = 'latex' -- treat .tex as latex
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

-- latex reflow using latexindent and conform
vim.api.nvim_create_user_command('TexReflow', function(a)
  local range = nil
  if a.count ~= -1 then
    local last = vim.api.nvim_buf_get_lines(0, a.line2 - 1, a.line2, true)[1]
    range = { start = { a.line1, 0 }, ['end'] = { a.line2, #last } }
  end
  require('conform').format {
    formatters = { 'latexindent_reflow' },
    lsp_format = 'never',
    async = true,
    range = range,
  }
end, { range = true })

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'tex',
  callback = function(ev)
    vim.keymap.set('n', '<leader>lf', function()
      local s = vim.fn.line "'{" + 1 -- first line after the leading blank
      local e = vim.fn.line "'}" - 1 -- last line before the trailing blank
      vim.cmd(('silent %d,%dTexReflow'):format(s, e))
    end, { buffer = ev.buf, desc = 'Reflow using latexindent' })

    vim.keymap.set('x', '<leader>lf', function()
      vim.cmd 'normal! \27'
      local s = vim.fn.line "'<"
      local e = vim.fn.line "'>"
      vim.cmd(('silent %d,%dTexReflow'):format(s, e))
    end, { buffer = ev.buf, desc = 'Reflow using latexindent' })
  end,
})
