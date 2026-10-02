vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2

-- Do not word wrap for orgmode to deal with ugly links
-- instead, hard wrap manually using gq as necessary
vim.opt_local.wrap = false

-- Map "meta return" in insert mode
vim.keymap.set(
  'i',
  '<S-CR>',
  '<cmd>lua require("orgmode").action("org_mappings.meta_return")<CR>',
  { silent = true, buffer = true, desc = 'Meta return (insert mode)' }
)

-- Convenience mapping to convert md links to org
vim.keymap.set('n', '<leader>olc', function()
  local line = vim.api.nvim_get_current_line()
  local new_line = line:gsub('%[([^%]]+)%]%(([^)]+)%)', '[[%2][%1]]')
  vim.api.nvim_set_current_line(new_line)
end, { buffer = true, desc = 'Convert markdown links on current line' })
