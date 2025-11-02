return {
  'copilotlsp-nvim/copilot-lsp',
  dependencies = {
    'zbirenbaum/copilot.lua',
  },
  opts = {},
  config = function(_, opts)
    require('copilot-lsp').setup(opts)
  end,
}
