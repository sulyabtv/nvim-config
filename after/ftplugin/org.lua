vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2

-- do not word wrap for orgmode to deal with ugly links
-- instead, hard wrap manually using gq as necessary
vim.opt_local.wrap = false

-- map "meta return" in insert mode
vim.keymap.set(
  'i',
  '<S-CR>',
  '<cmd>lua require("orgmode").action("org_mappings.meta_return")<CR>',
  { silent = true, buffer = true, desc = 'Meta return (insert mode)' }
)
