return {
  'saghen/blink.cmp',
  event = 'InsertEnter', -- ← ensures it actually loads
  version = '*',
  dependencies = {
    'rafamadriz/friendly-snippets',
    'L3MON4D3/LuaSnip', -- snippets provider needs a snippet engine
    'fang2hou/blink-copilot',
  },
  opts = {
    sources = {
      -- enable LSP (gopls) + common fallbacks; keep Copilot too
      default = { 'lsp', 'copilot', 'path', 'buffer', 'snippets' },

      -- Per-filetype sources
      per_filetype = {
        go = { 'lsp', 'copilot', 'path', 'buffer', 'snippets' },
        lua = { 'lsp', 'copilot', 'path', 'buffer', 'snippets' },
      },

      -- Only override providers you customize (keep built-ins untouched)
      providers = {
        copilot = {
          name = 'copilot',
          module = 'blink-copilot',
          score_offset = 100,
          async = true,
          transform_items = function(_, items)
            local CompletionItemKind = require('blink.cmp.types').CompletionItemKind
            for _, item in ipairs(items) do
              item.kind = CompletionItemKind.Copilot
            end
            return items
          end,
        },
        lsp = {
          name = 'LSP',
          module = 'blink.cmp.sources.lsp',
          score_offset = 90, -- Higher than Copilot for LSP items
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
      documentation = { auto_show = true },
    },
  },
}
