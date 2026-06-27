local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add { gh 'stevearc/conform.nvim' }

require('conform').setup {
  notify_on_error = false,

  format_on_save = function(bufnr)
    -- enable or override formatters for on-save formatting
    local enabled_filetypes = {
      lua = true,
      python = true,
      markdown = true,
      rust = true,
      json = true,
      jsonc = true,
      tex = 'trim_whitespace', -- for latex, only trim whitespace on save
      sh = true,
    }

    local choice = enabled_filetypes[vim.bo[bufnr].filetype]
    if not choice then return nil end
    local opts = { timeout_ms = 500, lsp_fallback = true }
    if type(choice) == 'string' then opts.formatters = { choice } end
    return opts
  end,

  default_format_opts = {
    -- Use external formatters if configured below, otherwise use LSP formatting.
    -- Set to `false` to disable LSP formatting entirely.
    lsp_format = 'fallback',
  },

  formatters_by_ft = {
    lua = { 'stylua' },
    python = { 'ruff_format' },
    markdown = { 'prettier' },
    rust = { 'rustfmt' },
    json = { 'prettier' },
    jsonc = { 'prettier' },
    tex = { 'tex-fmt' },
    sh = { 'shfmt' },
    ['_'] = { 'trim_whitespace' },
  },

  -- custom formatters
  formatters = {
    latexindent_reflow = {
      command = 'latexindent',
      args = {
        '-m',
        '-y',
        table.concat({
          'defaultIndent:"  "',
          'modifyLineBreaks:oneSentencePerLine:manipulateSentences:1',
          'modifyLineBreaks:oneSentencePerLine:removeSentenceLineBreaks:0',
          'modifyLineBreaks:oneSentencePerLine:textWrapSentences:1',
          'modifyLineBreaks:oneSentencePerLine:sentenceIndent:"  "',
          'modifyLineBreaks:textWrapOptions:columns:80',
          'noAdditionalIndent:abstract:1',
          'noAdditionalIndentGlobal:ifElseFi:1',
        }, ','),
      },
      stdin = true,
    },
  },
}

vim.keymap.set({ 'n', 'v' }, '<leader>F', function() require('conform').format { async = true } end, { desc = 'Format buffer or selection' })
