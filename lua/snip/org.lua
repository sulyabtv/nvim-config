local ls = require 'luasnip'
local dates = require 'util.dates'

local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local f = ls.function_node

return {
  s('h1', { t '* ', i(1, 'heading'), i(0) }),
  s('h2', { t '** ', i(1, 'heading'), i(0) }),
  s('h3', { t '*** ', i(1, 'heading'), i(0) }),
  s('h4', { t '**** ', i(1, 'heading'), i(0) }),
  s('h5', { t '***** ', i(1, 'heading'), i(0) }),
  s('h6', { t '****** ', i(1, 'heading'), i(0) }),
  s('note', {
    t '[',
    f(dates.today '%Y-%m-%d', {}),
    t '] ',
    i(1, 'title'),
    t { '', ':PROPERTIES:', ':DATE: [' },
    f(dates.today '%Y-%m-%d %a', {}),
    t { ']', ':END:', '', '' },
    i(0),
  }),
  s('week', {
    f(function()
      local year, week, mon, sun = dates.iso_week '%Y-%m-%d %a'
      return ('%s Week %s [%s]--[%s]'):format(year, week, mon, sun)
    end, {}),
  }),
  s('link', {
    t '[[',
    i(1, 'target'),
    t '][',
    i(2, 'description'),
    t ']]',
    i(0),
  }),
  s('clipboard-link', {
    t '[[',
    f(function() return ((vim.fn.getreg '+'):gsub('\n$', ''):gsub('\n', ' ')) end, {}),
    t '][',
    i(1, 'description'),
    t ']]',
    i(0),
  }),
  s('papernote', {
    t '* ',
    i(1, 'title'),
    t { '', '', '- [[' },
    i(2, 'ITEM_LINK'),
    t { '][Zotero link]]', '', '** NABC', '', '*** Need', '', '- ' },
    i(3),
    t { '', '', '*** Approach', '', '- ' },
    i(4),
    t { '', '', '*** Benefits', '', '- ' },
    i(5),
    t { '', '', '*** Challenges', '', '- ' },
    i(6),
    t { '', '', '** Details', '', '- ' },
    i(7),
    t { '', '', '** Takeaways for my research', '', '- ' },
    i(0),
  }),
}
