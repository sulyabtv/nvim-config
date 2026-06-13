vim.pack.add { 'https://github.com/hedyhli/markdown-toc.nvim' }

require('mtoc').setup {
  toc_list = {
    markers = '-', -- use hyphens for list
  },
  auto_update = true, -- refresh TOCs on save
}
