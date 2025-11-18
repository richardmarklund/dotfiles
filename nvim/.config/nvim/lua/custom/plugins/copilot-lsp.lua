return {
  'copilotlsp-nvim/copilot-lsp',
  event = 'VeryLazy',
  dependencies = {
    'zbirenbaum/copilot.lua',
  },
  opts = {},
  config = function(_, opts)
    require('copilot-lsp').setup(opts)
  end,
}
