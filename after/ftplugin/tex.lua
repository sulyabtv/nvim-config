-- Latex reflow using latexindent
vim.api.nvim_create_user_command('TexReflow', function(a)
  if a.range == 0 then return end

  local lines = vim.api.nvim_buf_get_lines(0, a.line1 - 1, a.line2, false)
  local input = table.concat(lines, '\n')

  local args = {
    '-m',
    '-y',
    table.concat({
      'defaultIndent:"  "',
      'modifyLineBreaks:oneSentencePerLine:manipulateSentences:1',
      'modifyLineBreaks:oneSentencePerLine:removeSentenceLineBreaks:0',
      'modifyLineBreaks:oneSentencePerLine:textWrapSentences:1',
      'modifyLineBreaks:oneSentencePerLine:sentenceIndent:"  "',
      'modifyLineBreaks:textWrapOptions:columns:80',
      'noAdditionalIndent:abstract:1',
      'noAdditionalIndentGlobal:ifElseFi:1',
    }, ','),
  }

  local result = vim
    .system({ 'latexindent', unpack(args) }, {
      stdin = input,
      text = true,
    })
    :wait()

  if result.code ~= 0 then
    vim.notify('latexindent failed: ' .. (result.stderr or ''), vim.log.levels.ERROR)
    return
  end

  local output_lines = vim.split(result.stdout, '\n')
  if output_lines[#output_lines] == '' then table.remove(output_lines) end

  vim.api.nvim_buf_set_lines(0, a.line1 - 1, a.line2, false, output_lines)
end, { range = true })

vim.keymap.set('n', '<leader>lf', function()
  local orig = vim.api.nvim_win_get_cursor(0)
  vim.cmd 'normal! vip'
  vim.cmd 'normal! \27'
  local s = vim.fn.line "'<"
  local e = vim.fn.line "'>"
  vim.cmd(('silent %d,%dTexReflow'):format(s, e))
  pcall(vim.api.nvim_win_set_cursor, 0, orig)
end, { buffer = true, desc = 'Reflow paragraph using latexindent' })

vim.keymap.set('x', '<leader>lf', function()
  vim.cmd 'normal! \27'
  local s = vim.fn.line "'<"
  local e = vim.fn.line "'>"
  vim.cmd(('silent %d,%dTexReflow'):format(s, e))
end, { buffer = true, desc = 'Reflow selection using latexindent' })
