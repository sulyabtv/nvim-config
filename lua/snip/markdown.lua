local ls = require 'luasnip'
local dates = require 'util.dates'

local s, f = ls.snippet, ls.function_node

return {
  s('week', {
    f(function()
      local year, week, mon, sun = dates.iso_week '%Y/%m/%d'
      return ('%s Week %s (%s - %s)'):format(year, week, mon, sun)
    end, {}),
  }),
}
