return {
  'saghen/blink.cmp',
  event = 'VeryLazy', -- ← ensures it actually loads
  version = '*',
  dependencies = {
    'rafamadriz/friendly-snippets',
    'L3MON4D3/LuaSnip', -- snippets provider needs a snippet engine
  },
  opts = {
    sources = {
      -- enable LSP (gopls) + common fallbacks
      default = { 'lsp', 'path', 'buffer', 'snippets' },

      -- Per-filetype sources
      per_filetype = {
        go = { 'lsp', 'path', 'buffer', 'snippets' },
        lua = { 'lsp', 'path', 'buffer', 'snippets' },
      },

      -- Only override providers you customize (keep built-ins untouched)
      providers = {
        lsp = {
          name = 'LSP',
          module = 'blink.cmp.sources.lsp',
          score_offset = 90,
        },
        -- no need to define 'path', 'buffer', 'snippets' here;
        -- Blink's built-ins will register themselves
      },
    },

    appearance = {
      use_nvim_cmp_as_default = false,
      nerd_font_variant = 'mono',
    },

    signature = { enabled = true },

    completion = {
      -- Optional but nice
      trigger = { show_on_insert_on_trigger_character = true },
      list = { selection = { preselect = true, auto_insert = false } },
      documentation = { auto_show = true },
    },

    keymap = {
      preset = 'enter',
      ['<Up>'] = { 'select_prev', 'fallback' },
      ['<Down>'] = { 'select_next', 'fallback' },
      ['<S-Tab>'] = {
        'snippet_backward',
        function()
          local ok_sug, suggestion = pcall(require, 'copilot.suggestion')
          if ok_sug and suggestion.is_visible() then
            suggestion.dismiss()
            return true
          end
        end,
        'select_prev',
        'fallback',
      },
      ['<Tab>'] = {
        'snippet_forward',
        function()
          local ok_sug, suggestion = pcall(require, 'copilot.suggestion')
          if ok_sug and suggestion.is_visible() then
            suggestion.accept()
            return true
          end
        end,
        function()
          if vim.lsp and vim.lsp.inline_completion then
            return vim.lsp.inline_completion.get()
          end
        end,
        'fallback',
      },
      ['<CR>'] = { 'accept', 'fallback' },
    },
  },
}
