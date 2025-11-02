return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  event = 'InsertEnter',
  opts = {
    suggestion = {
      enabled = true,
      auto_trigger = true,
    },
    panel = { enabled = false },
    nes = {
      enabled = false,
    },
    copilot_node_command = 'node',
  },
  config = function(_, opts)
    local copilot = require 'copilot'
    copilot.setup(opts)

    local enable = vim.lsp and vim.lsp.enable
    if enable then
      enable 'copilot'
    end
  end,
}
