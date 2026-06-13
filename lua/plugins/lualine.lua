vim.pack.add {
  'https://github.com/nvim-lualine/lualine.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
}

require('lualine').setup {
  options = {
    globalstatus = true, -- one global statusline
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
        require('noice').api.status.message.get_hl,
        cond = require('noice').api.status.message.has,
      },
    },
    lualine_x = {
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
