vim.pack.add {
  { src = 'https://github.com/nvim-orgmode/orgmode' },
  { src = 'https://github.com/danilshvalov/org-modern.nvim' },
  { src = 'https://github.com/nvim-orgmode/org-bullets.nvim' },
}

local Menu = require 'org-modern.menu'

require('orgmode').setup {
  org_agenda_files = '~/syncthing/**/*',
  org_default_notes_file = '~/syncthing/uncategorized.org',
  org_startup_indented = true,
  org_startup_folded = 'content',
  org_hide_emphasis_markers = true,
  org_indent_mode_turns_on_hiding_stars = false,
  org_blank_before_new_entry = { heading = false, plain_list_item = false },
  org_cycle_separator_lines = 1,
  org_id_link_to_org_use_id = true,
  org_priority_highest = 'A',
  org_priority_lowest = 'E',
  org_priority_default = 'C',
  org_todo_keywords = {
    'TODO(t)',
    'PROGRESS(p)',
    'BLOCKED(b)',
    '|',
    'DONE(d)',
    'DELEGATED(l)',
    'CANCELED(c)',
  },
  ui = {
    menu = {
      ---@diagnostic disable-next-line: redundant-parameter
      handler = function(data) Menu:new():open(data) end,
    },
    input = { use_vim_ui = true },
  },
}
-- Experimental LSP support
vim.lsp.enable 'org'

require('org-bullets').setup()
