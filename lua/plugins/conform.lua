local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add { gh 'stevearc/conform.nvim' }

require('conform').setup {
  notify_on_error = false,

  format_on_save = function(bufnr)
    -- enable or override formatters for on-save formatting
    local enabled_filetypes = {
      bib = true,
      bibtex = true,
      json = true,
      jsonc = true,
      lua = true,
      markdown = true,
      org = 'trim_whitespace',
      python = true,
      rust = true,
      sh = true,
      tex = 'trim_whitespace',
    }

    local choice = enabled_filetypes[vim.bo[bufnr].filetype]
    if not choice then return nil end
    local opts = { timeout_ms = 1000, lsp_fallback = true }
    if type(choice) == 'string' then opts.formatters = { choice } end
    return opts
  end,

  default_format_opts = {
    -- Use external formatters if configured below, otherwise use LSP formatting.
    -- Set to `false` to disable LSP formatting entirely.
    lsp_format = 'fallback',
  },

  formatters_by_ft = {
    bib = { 'bibtex-tidy' },
    bibtex = { 'bibtex-tidy' },
    json = { 'prettier' },
    jsonc = { 'prettier' },
    lua = { 'stylua' },
    markdown = { 'prettier' },
    python = { 'ruff_format' },
    rust = { 'rustfmt' },
    sh = { 'shfmt' },
    tex = { 'tex-fmt' },
    ['_'] = { 'trim_whitespace' },
  },

  formatters = {
    ['bibtex-tidy'] = {
      command = 'bibtex-tidy',
      args = {
        '--curly',
        '--numeric',
        '--blank-lines',
        '--duplicates=key,doi,citation',
        '--remove-empty-fields',
        '--trailing-commas',
        '--enclosing-braces',
      },
      stdin = true,
    },
  },
}

vim.keymap.set({ 'n', 'v' }, '<leader>F', function() require('conform').format { async = true } end, { desc = 'Format buffer or selection' })
