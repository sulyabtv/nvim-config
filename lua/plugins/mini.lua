local function gh(repo) return 'https://github.com/' .. repo end

-- [[ mini.nvim ]]
--  A collection of various small independent plugins/modules
vim.pack.add { gh 'nvim-mini/mini.nvim' }

-- If a nerd font is available, load the icons module for pretty icons in various plugins.
if vim.g.have_nerd_font then
  require('mini.icons').setup()
  -- Used for backwards compatibility with plugins that require `nvim-web-devicons` (e.g. telescope.nvim)
  MiniIcons.mock_nvim_web_devicons()
end

-- Better Around/Inside textobjects
--
-- Examples:
--  - va)  - [V]isually select [A]round [)]paren
--  - yaNb - [Y]ank [A]round [N]ext [B]racket
--  - diLf - [D]elete [I]nside [L]ast [F]unction
--  - ci'  - [C]hange [I]nside [']quote
require('mini.ai').setup {
  n_lines = 100,
  silent = true,
  mappings = {
    around_next = 'aN',
    inside_next = 'iN',
    around_last = 'aL',
    inside_last = 'iL',
  },
}

-- Add/delete/replace surroundings (brackets, quotes, etc.)
--
-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
-- - sd'   - [S]urround [D]elete [']quotes
-- - sr)'  - [S]urround [R]eplace [)] [']
require('mini.surround').setup {
  -- remaps to deconflict with leap
  mappings = {
    add = 'gza',
    delete = 'gzd',
    find = 'gzf',
    find_left = 'gzF',
    highlight = 'gzh',
    replace = 'gzr',
  },
}

-- Alt-h/j/k/l to move line or selection
require('mini.move').setup()

require('mini.pairs').setup()
require('mini.comment').setup()
