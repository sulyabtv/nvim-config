vim.pack.add { 'https://github.com/mfussenegger/nvim-lint' }

local lint = require 'lint'
lint.linters_by_ft = {
  markdown = { 'markdownlint' },
  tex = { 'chktex' },
}

-- chktex config
-- chktex returns non-zero for basically everything
lint.linters.chktex.ignore_exitcode = true
-- suppress noisy chktex warnings
table.insert(lint.linters.chktex.args, '-n1')
table.insert(lint.linters.chktex.args, '-n8')
table.insert(lint.linters.chktex.args, '-n24')

-- markdownlint config
-- pass in markdownlint config if it exists
local config_path = vim.fn.expand '~/.markdownlint.json'
if vim.uv.fs_stat(config_path) then
  local markdownlint = lint.linters.markdownlint
  table.insert(markdownlint.args, 1, config_path)
  table.insert(markdownlint.args, 1, '--config')
end

-- Create autocommand which carries out the actual linting
-- on the specified events.
local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
  group = lint_augroup,
  callback = function()
    -- Only run the linter in buffers that you can modify in order to
    -- avoid superfluous noise, notably within the handy LSP pop-ups that
    -- describe the hovered symbol using Markdown.
    if vim.bo.modifiable then lint.try_lint() end
  end,
})
