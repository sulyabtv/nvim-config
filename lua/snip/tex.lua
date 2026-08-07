local ls = require 'luasnip'
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node

return {
  -- Double quotes
  s('dq', {
    t [[``]],
    i(1, 'quoted text'),
    t [['' ]],
    i(0),
  }),
  -- Single quotes
  s('sq', {
    t [[`]],
    i(1, 'quoted text'),
    t [[' ]],
    i(0),
  }),
  -- \emph
  s('emph', { t [[\emph{]], i(1), t [[}]] }),
}
