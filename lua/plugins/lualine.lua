vim.pack.add {
  'https://github.com/nvim-lualine/lualine.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
}

local function macro_recording()
  local reg = vim.fn.reg_recording()
  if reg == '' then return '' end
  return 'recording @' .. reg
end

require('lualine').setup {
  options = {
    globalstatus = true, -- one global statusline
    refresh = {
      events = {
        'WinEnter',
        'BufEnter',
        'BufWritePost',
        'SessionLoadPost',
        'FileChangedShellPost',
        'VimResized',
        'Filetype',
        'CursorMoved',
        'CursorMovedI',
        'ModeChanged',
        'RecordingEnter',
        'RecordingLeave',
      },
    },
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = {
      { 'branch' },
      { 'diff' },
      { 'diagnostics' },
    },
    lualine_c = {
      {
        -- message
        ---@diagnostic disable-next-line: undefined-field
        require('noice').api.status.message.get_hl,
        ---@diagnostic disable-next-line: undefined-field
        cond = require('noice').api.status.message.has,
      },
    },
    lualine_x = {
      { macro_recording, color = 'WarningMsg' },
      { 'searchcount' },
      { 'lsp_status' },
    },
    lualine_y = {
      { 'encoding' },
      { 'fileformat' },
      { 'filetype' },
    },
    lualine_z = {
      { 'progress' },
      { 'location' },
    },
  },
}
