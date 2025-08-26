return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'j-hui/fidget.nvim',
    {
      'ravitemer/codecompanion-history.nvim',
      lazy = true,
    },
  },
  config = function()
    require('codecompanion').setup {
      extensions = {
        history = {
          enabled = true,
          opts = {
            keymap = 'gh',
            save_chat_keymap = 'sc',
            auto_save = true,
            expiration_days = 0,
            picker = 'telescope',
            picker_keymaps = {
              rename = { n = 'r', i = '<M-r>' },
              delete = { n = 'd', i = '<M-d>' },
              duplicate = { n = '<C-y>', i = '<C-y>' },
            },
            auto_generate_title = true,
            title_generation_opts = {
              adapter = nil,
              model = nil,
              refresh_every_n_prompts = 0,
              max_refreshes = 3,
            },
            continue_last_chat = false,
            delete_on_clearing_chat = false,
            dir_to_save = vim.fn.stdpath 'data' .. '/codecompanion-history',
            enable_logging = false,
            chat_filter = nil,
          },
        },
      },
    }
    -- Keymaps using command line interface
    vim.keymap.set('n', '<leader>aa', ':CodeCompanionActions<CR>', { noremap = true, silent = true, desc = 'Open CodeCompanion Actions' })
    vim.keymap.set('n', '<leader>ac', ':CodeCompanionChat<CR>', { noremap = true, silent = true, desc = 'Open CodeCompanion Chat' })
    vim.keymap.set('n', '<leader>ah', ':CodeCompanionHistory<CR>', { noremap = true, silent = true, desc = 'Open CodeCompanion Chat History' })

    -- Prompt-based actions (Lua only)
    vim.keymap.set('v', '<leader>at', function()
      require('codecompanion').prompt 'tests'
    end, { noremap = true, silent = true, desc = 'Generate unit tests' })

    vim.keymap.set('n', '<leader>ae', function()
      require('codecompanion').prompt 'explain'
    end, { noremap = true, silent = true, desc = 'Explain buffer' })

    vim.keymap.set('n', '<leader>al', function()
      require('codecompanion').prompt 'lsp'
    end, { noremap = true, silent = true, desc = 'Explain LSP diagnostics' })
  end,
  init = function()
    require('custom.plugins.fidget-spinner'):init()
  end,
}
