return {
  'olimorris/codecompanion.nvim',
  cmd = { 'CodeCompanion', 'CodeCompanionActions', 'CodeCompanionChat', 'CodeCompanionHistory' },
  keys = {
    { '<leader>aa', '<cmd>CodeCompanionActions<CR>', desc = 'Open CodeCompanion Actions' },
    { '<leader>ac', '<cmd>CodeCompanionChat<CR>', desc = 'Open CodeCompanion Chat' },
    { '<leader>ah', '<cmd>CodeCompanionHistory<CR>', desc = 'Open CodeCompanion Chat History' },
    {
      '<leader>at',
      mode = 'v',
      function()
        require('codecompanion').prompt 'tests'
      end,
      desc = 'Generate unit tests',
    },
    {
      '<leader>ae',
      function()
        require('codecompanion').prompt 'explain'
      end,
      desc = 'Explain buffer',
    },
    {
      '<leader>al',
      function()
        require('codecompanion').prompt 'lsp'
      end,
      desc = 'Explain LSP diagnostics',
    },
  },
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
            picker = 'snacks',
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
  end,
  init = function()
    require('custom.plugins.fidget-spinner'):init()
  end,
}
