local ls = require 'luasnip'
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local f = ls.function_node

local function today(fmt)
  return function() return os.date(fmt) end
end

return {
  s('note', {
    t '[',
    f(today '%Y-%m-%d', {}),
    t '] ',
    i(1, 'title'),
    t { '', ':PROPERTIES:', ':DATE: [' },
    f(today '%Y-%m-%d %a', {}),
    t { ']', ':END:', '', '' },
    i(0),
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
    f(function() return (vim.fn.getreg '+' or ''):gsub('\n$', ''):gsub('\n', ' ') end, {}),
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
