local M = {}

local function weekday_iso()
  local wday = tonumber(os.date '%w') -- Sun=0..Sat=6
  return wday == 0 and 7 or wday -- Mon=1..Sun=7
end

--- Date `days` from today, formatted with `fmt`
function M.offset(days, fmt)
  local now = os.date '*t'
  return os.date(fmt, os.time { year = now.year, month = now.month, day = now.day + days, hour = 12 })
end

--- ISO week info: year, week number, and Monday/Sunday formatted with `fmt`
function M.iso_week(fmt)
  local wd = weekday_iso()
  return os.date '%G', os.date '%V', M.offset(1 - wd, fmt), M.offset(7 - wd, fmt)
end

--- Returns a function producing today's date in `fmt`
function M.today(fmt)
  return function() return M.offset(0, fmt) end
end

return M
