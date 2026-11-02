local ls = require 'luasnip'
local dates = require 'util.dates'

local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local f = ls.function_node

return {
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
  s('h1', { t '* ', i(1, 'heading'), i(0) }),
  s('h2', { t '** ', i(1, 'heading'), i(0) }),
  s('h3', { t '*** ', i(1, 'heading'), i(0) }),
  s('h4', { t '**** ', i(1, 'heading'), i(0) }),
  s('h5', { t '***** ', i(1, 'heading'), i(0) }),
  s('h6', { t '****** ', i(1, 'heading'), i(0) }),
}
