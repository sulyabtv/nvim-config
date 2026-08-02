local function gh(repo) return 'https://github.com/' .. repo end

-- [[ Snippet Engine ]]

-- NOTE: You can also specify plugin using a version range for its git tag.
--  See `:help vim.version.range()` for more info
vim.pack.add { { src = gh 'L3MON4D3/LuaSnip', version = vim.version.range '2.*' } }
require('luasnip').setup {}

-- Fix for weird jumps that sometimes happen when pressing tab
-- See https://github.com/L3MON4D3/LuaSnip/issues/258
vim.api.nvim_create_autocmd('ModeChanged', {
  pattern = '*',
  callback = function()
    if
      ---@diagnostic disable-next-line: undefined-field
      ((vim.v.event.old_mode == 's' and vim.v.event.new_mode == 'n') or vim.v.event.old_mode == 'i')
      and require('luasnip').session.current_nodes[vim.api.nvim_get_current_buf()]
      and not require('luasnip').session.jump_active
    then
      require('luasnip').unlink_current()
    end
  end,
})

-- `friendly-snippets` contains a variety of premade snippets.
--    See the README about individual language/framework/plugin snippets:
--    https://github.com/rafamadriz/friendly-snippets
vim.pack.add { gh 'rafamadriz/friendly-snippets' }
require('luasnip.loaders.from_vscode').lazy_load()

-- load my own snippets
require('luasnip.loaders.from_lua').lazy_load {
  paths = { vim.fn.stdpath 'config' .. '/lua/snip' },
}

-- [[ Autocomplete Engine ]]
vim.pack.add { { src = gh 'saghen/blink.cmp', version = vim.version.range '1.*' } }
require('blink.cmp').setup {
  keymap = {
    -- C-space: Open menu or open docs if already open
    -- C-n/C-p or Up/Down: Select next/previous item
    -- C-e: Hide menu
    -- C-k: Toggle signature help (if signature.enabled = true)
    preset = 'super-tab',
    ['<Esc>'] = { 'cancel', 'fallback' },
  },
  appearance = {
    nerd_font_variant = 'mono',
  },
  completion = {
    menu = { auto_show = true },
    trigger = {
      show_on_insert = true,
      show_on_blocked_trigger_characters = {},
      show_on_x_blocked_trigger_characters = {},
    },
    documentation = { auto_show = true, auto_show_delay_ms = 500 },
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
    per_filetype = {
      markdown = { inherit_defaults = true, 'mkdnflow' },
      org = { 'orgmode', 'path', 'snippets', 'buffer' }, -- no lsp
    },
    providers = {
      lsp = {
        override = {
          get_trigger_characters = function(self)
            local trigger_characters = self:get_trigger_characters()
            vim.list_extend(trigger_characters, { '\n', '\t', ' ' })
            return trigger_characters
          end,
        },
      },
      mkdnflow = {
        name = 'Mkdnflow',
        module = 'mkdnflow.completion.blink',
      },
      orgmode = {
        name = 'Orgmode',
        module = 'orgmode.org.autocompletion.blink',
      },
      buffer = {
        -- constraints to reduce noise
        score_offset = -3,
        max_items = 5,
        min_keyword_length = 3,
      },
      snippets = {
        -- TODO: Remove this hack once friendly-snippets fixes their duplication
        transform_items = function(_, items)
          local seen, out = {}, {}
          for _, item in ipairs(items) do
            local key = item.insertText or item.label
            if not seen[key] then
              seen[key] = true
              out[#out + 1] = item
            end
          end
          return out
        end,
      },
    },
  },
  snippets = { preset = 'luasnip' },
  fuzzy = { implementation = 'lua' },
  cmdline = {
    enabled = true,
    keymap = {
      preset = 'inherit',
      ['<Esc>'] = {
        function()
          if vim.fn.getcmdtype() == ':' and require('blink.cmp').is_visible() then
            -- If completion menu is active, just close it
            require('blink.cmp').hide()
            return true
          end
          -- Completion not active => close the cmdline
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-c>', true, false, true), 'n', false)
          return true
        end,
      },
    },
    completion = {
      menu = {
        -- Only show completions for commands
        auto_show = function() return vim.fn.getcmdtype() == ':' end,
      },
    },
  },
  signature = {
    enabled = true,
    window = { border = 'solid', show_documentation = true },
  },
}
