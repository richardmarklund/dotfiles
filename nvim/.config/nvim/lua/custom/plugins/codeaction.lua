return {
  'aznhe21/actions-preview.nvim',
  event = 'LspAttach',
  dependencies = {
    { 'MunifTanjim/nui.nvim', optional = true },
    { 'folke/snacks.nvim', optional = true },
  },
  keys = {
    {
      '<leader>ca',
      function()
        require('actions-preview').code_actions()
      end,
      mode = { 'n', 'x' },
      desc = 'Code Action (preview)',
    },
  },
  opts = (function()
    -- Build opts without eagerly requiring optional pickers to avoid startup errors
    local opts = {
      diff = { ctxlen = 4 },
      highlight_command = {},
      backend = { 'snacks', 'minipick', 'nui' },
      nui = {
        dir = 'col',
        keymap = nil,
        layout = {
          position = '50%',
          size = { width = '80%', height = '90%' },
          min_width = 60,
          min_height = 15,
          relative = 'editor',
        },
        preview = {
          size = '65%',
          border = { style = 'rounded', padding = { 0, 1 } },
        },
        select = {
          size = '35%',
          border = { style = 'rounded', padding = { 0, 1 } },
        },
      },
      snacks = { layout = { preset = 'default' } },
    }

    return opts
  end)(),
  config = function(_, opts)
    require('actions-preview').setup(opts)
  end,
}
