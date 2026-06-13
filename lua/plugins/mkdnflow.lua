vim.pack.add { 'https://github.com/jakewvincent/mkdnflow.nvim' }

require('mkdnflow').setup {
  modules = {
    folds = false, -- use treesitter for folding
    foldtext = false,
    bib = false,
    yaml = false,
  },
  path_resolution = {
    primary = 'current',
    fallback = 'first',
  },
  to_do = {
    statuses = {
      complete = { marker = 'x' }, -- lowercase x
    },
  },
  mappings = {
    MkdnNextLink = false, -- free <Tab>
    MkdnPrevLink = false, -- free <S-Tab>
    MkdnFollowLink = false, -- gd / C-o instead
    MkdnEnter = { { 'i', 'n', 'v' }, '<CR>' }, -- list continuation
    MkdnCreateLinkFromClipboard = { { 'n', 'v' }, '<leader>pl' },
    MkdnUpdateNumbering = { 'n', '<leader>un' },
  },
}
