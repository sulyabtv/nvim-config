vim.pack.add {
  'https://github.com/folke/snacks.nvim',
}

require('snacks').setup {
  animate = { enabled = true },
  bigfile = { enabled = true },
  bufdelete = { enabled = true },
  dim = { enabled = true },
  explorer = { enabled = true, replace_netrw = false },
  indent = { enabled = true },
  input = { enabled = true },
  lazygit = {
    enabled = true,
    configure = true,
    win = { position = 'float', width = 0.9, height = 0.9 },
  },
  notifier = { enabled = true },
  picker = {
    enabled = true,
    sources = {
      explorer = {
        hidden = true,
        ignored = true,
        exclude = { '.git' },
        auto_close = true,
        layout = { preset = 'default', preview = true },
      },
      files = {
        hidden = true,
        ignored = true,
      },
      grep = {
        hidden = true,
        ignored = true,
      },
    },
  },
  rename = { enabled = true },
  scope = { enabled = true },
  terminal = { enabled = true, win = { position = 'bottom', height = 12 } },
  toggle = { enabled = true },
  words = { enabled = true },
  zen = { enabled = true },
}

-- helper: current file's dir, falling back to cwd
local function file_dir()
  local f = vim.api.nvim_buf_get_name(0)
  if f == '' then return vim.fn.getcwd() end
  return vim.fs.dirname(f)
end

-- find stuff
vim.keymap.set('n', '<leader>fe', function() Snacks.explorer.reveal() end, { desc = 'Open file explorer' })
vim.keymap.set('n', '<leader>ff', function() Snacks.picker.files() end, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', function() Snacks.picker.grep() end, { desc = 'Grep (live)' })
vim.keymap.set('n', '<leader>fr', function() Snacks.picker.recent() end, { desc = 'Recent files' })
vim.keymap.set({ 'n', 'x' }, '<leader>fw', function() Snacks.picker.grep_word() end, { desc = 'Grep word under cursor' })
vim.keymap.set('n', '<leader>fh', function() Snacks.picker.help() end, { desc = 'Help pages' })
vim.keymap.set('n', '<leader>fi', function() Snacks.picker.lines() end, { desc = 'Find in buffer' })
vim.keymap.set('n', '<leader>fb', function() Snacks.picker.buffers() end, { desc = 'Find buffers' })
vim.keymap.set('n', '<leader>f:', function() Snacks.picker.commands() end, { desc = 'Find commands' })
vim.keymap.set('n', '<leader>fk', function() Snacks.picker.keymaps() end, { desc = 'Find keymaps' })

-- git stuff
vim.keymap.set('n', '<leader>gD', function() Snacks.picker.git_diff { cwd = file_dir() } end, { desc = 'Git diff' })
vim.keymap.set('n', '<leader>gd', function() Snacks.lazygit.open { cwd = file_dir() } end, { desc = 'Lazygit Dashboard' })
vim.keymap.set('n', '<leader>glr', function() Snacks.lazygit.log { cwd = file_dir() } end, { desc = 'Lazygit Reflog' })
vim.keymap.set('n', '<leader>glf', function() Snacks.picker.git_log_file { cwd = file_dir() } end, { desc = 'Git log (file)' })
vim.keymap.set('n', '<leader>gll', function() Snacks.picker.git_log_line { cwd = file_dir() } end, { desc = 'Git log (line)' })
vim.keymap.set('n', '<leader>glc', function() Snacks.picker.git_log { cwd = file_dir() } end, { desc = 'Git log' })
vim.keymap.set('n', '<leader>gs', function() Snacks.picker.git_status { cwd = file_dir() } end, { desc = 'Git status' })
vim.keymap.set('n', '<leader>gS', function() Snacks.picker.git_stash { cwd = file_dir() } end, { desc = 'Git stash' })
vim.keymap.set('n', '<leader>gc', function() Snacks.picker.git_log { cwd = file_dir() } end, { desc = 'Git commits' })
vim.keymap.set('n', '<leader>gb', function() Snacks.picker.git_branches { cwd = file_dir() } end, { desc = 'Git branches' })

-- lsp stuff
vim.keymap.set('n', '<leader>ls', function() Snacks.picker.lsp_symbols() end, { desc = 'Document symbols' })
vim.keymap.set('n', '<leader>lS', function() Snacks.picker.lsp_workspace_symbols() end, { desc = 'Workspace symbols' })
vim.keymap.set('n', '<leader>lr', function() Snacks.picker.lsp_references() end, { desc = 'References' })
vim.keymap.set('n', '<leader>ld', function() Snacks.picker.lsp_definitions() end, { desc = 'Definitions' })
vim.keymap.set('n', '<leader>lD', function() Snacks.picker.lsp_declarations() end, { desc = 'Declarations' })
vim.keymap.set('n', '<leader>lg', function() Snacks.picker.diagnostics_buffer() end, { desc = 'Diagnostics (buffer)' })
vim.keymap.set('n', '<leader>lG', function() Snacks.picker.diagnostics() end, { desc = 'Diagnostics (workspace)' })
vim.keymap.set('n', '<leader>li', function() Snacks.picker.lsp_incoming_calls() end, { desc = 'Incoming calls' })
vim.keymap.set('n', '<leader>lo', function() Snacks.picker.lsp_outgoing_calls() end, { desc = 'Outgoing calls' })
vim.keymap.set('n', ']r', function() Snacks.words.jump(1) end, { desc = 'Next reference' })
vim.keymap.set('n', '[r', function() Snacks.words.jump(-1) end, { desc = 'Prev reference' })

-- history
vim.keymap.set('n', '<leader>h:', function() Snacks.picker.command_history() end, { desc = 'Command history' })
vim.keymap.set('n', '<leader>hn', function() Snacks.notifier.show_history() end, { desc = 'Notification history' })
vim.keymap.set('n', '<leader>hs', function() Snacks.picker.search_history() end, { desc = 'Search history' })
vim.keymap.set('n', '<leader>hu', function() Snacks.picker.undo() end, { desc = 'Undo history' })

-- picker
vim.keymap.set('n', '<leader>pc', function() Snacks.picker.colorschemes() end, { desc = 'Choose color scheme' })
vim.keymap.set('n', '<leader>pr', function() Snacks.picker.resume() end, { desc = 'Resume last picker' })
vim.keymap.set('n', '<leader>pp', function() Snacks.picker.pickers() end, { desc = 'Show all pickers' })

-- general
vim.keymap.set('n', '<leader>x', function() Snacks.bufdelete() end, { desc = 'Close current buffer' })
vim.keymap.set('n', '<leader>.', function() Snacks.scratch() end, { desc = 'Toggle scratch buffer' })
vim.keymap.set('n', '<leader>S', function() Snacks.scratch.select() end, { desc = 'Select scratch buffer' })
vim.keymap.set('n', '<leader>tt', function() Snacks.terminal.toggle() end, { desc = 'Toggle terminal (bottom, 15 lines)' })
