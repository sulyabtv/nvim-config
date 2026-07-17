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
    t { ']', ':END:', '' },
    i(0),
  }),
}
