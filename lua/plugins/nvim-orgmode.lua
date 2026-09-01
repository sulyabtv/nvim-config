vim.pack.add {
  { src = 'https://github.com/nvim-orgmode/orgmode' },
  { src = 'https://github.com/nvim-orgmode/org-bullets.nvim' },
}

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
  org_log_into_drawer = 'LOGBOOK',
  org_agenda_hide_empty_blocks = true,
  org_agenda_text_search_extra_files = { 'agenda-archives' },
  org_agenda_span = 'day',

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

  org_agenda_custom_commands = {
    o = {
      description = 'Overdue',
      types = {
        {
          type = 'tags_todo',
          match = 'DEADLINE<"<today>"|SCHEDULED<"<today>"',
          org_agenda_overriding_header = 'Overdue',
          -- merge with agenda view if these can be excluded from it
        },
      },
    },
    n = {
      description = 'Notes',
      types = {
        {
          type = 'tags',
          match = '+note+DATE<"<+1d>"',
          org_agenda_overriding_header = 'Notes',
          -- would be nice to sort by note date or alphabetically
        },
      },
    },
    x = {
      description = 'Meetings',
      types = {
        {
          type = 'tags',
          match = '+meeting+DATE<"<+1d>"',
          org_agenda_overriding_header = 'Meetings',
          -- would be nice to sort by note date or alphabetically
        },
      },
    },
    T = {
      description = 'Talks',
      types = {
        {
          type = 'tags',
          match = '+talk+DATE<"<+1d>"|+conference',
          org_agenda_overriding_header = 'Talks',
          -- would be nice to sort by note date or alphabetically
        },
      },
    },
  },

  org_capture_templates = {
    c = {
      description = 'Generic',
      template = '* %?',
    },
  },

  mappings = {
    org = {
      org_next_visible_heading = ']]',
      org_previous_visible_heading = '[[',
      org_forward_heading_same_level = ']h',
      org_backward_heading_same_level = '[h',
      outline_up_heading = '[p',
    },
  },
}
-- Experimental LSP support
vim.lsp.enable 'org'

require('org-bullets').setup()

-- Convenience mapping to convert md links to org
vim.keymap.set('n', '<leader>olc', function()
  local line = vim.api.nvim_get_current_line()
  local new_line = line:gsub('%[([^%]]+)%]%(([^)]+)%)', '[[%2][%1]]')
  vim.api.nvim_set_current_line(new_line)
end, { desc = 'Convert markdown links on current line' })

-- Make verbatim visually distinct from code
vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    vim.api.nvim_set_hl(0, '@org.verbatim', { link = 'Constant' })
    vim.api.nvim_set_hl(0, '@org.verbatim.delimiter', { link = 'Constant' })
  end,
})
