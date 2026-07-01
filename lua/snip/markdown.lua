local ls = require 'luasnip'
local s, t, f = ls.snippet, ls.text_node, ls.function_node

local function date_offset(days) return os.date('%Y/%m/%d', os.time() + days * 86400) end
local function weekday_iso()
  local wday = tonumber(os.date '%w') -- Sun=0..Sat=6
  return wday == 0 and 7 or wday -- Mon=1..Sun=7
end

return {
  s('week', {
    f(function() return os.date '%Y' end),
    t ' Week ',
    f(function() return os.date '%V' end),
    t ' (',
    f(function() return date_offset(-(weekday_iso() - 1)) end), -- Monday
    t ' - ',
    f(function() return date_offset(7 - weekday_iso()) end), -- Sunday
    t ')',
  }, { key = 'week_snippet' }),
}
