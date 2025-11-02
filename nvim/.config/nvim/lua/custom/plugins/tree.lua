vim.keymap.set('n', '<leader>e', function()
  require('lazy').load { plugins = { 'neo-tree.nvim' } }

  local ok, neo_cmd = pcall(require, 'neo-tree.command')
  if not ok then
    vim.cmd 'Neotree toggle position=left'
    return
  end

  local current_path = vim.api.nvim_buf_get_name(0)
  if current_path == '' then
    neo_cmd.execute {
      source = 'filesystem',
      position = 'left',
      toggle = true,
    }
    return
  end

  neo_cmd.execute {
    source = 'filesystem',
    position = 'left',
    toggle = true,
    reveal = true,
    reveal_file = current_path,
    reveal_force_cwd = false,
  }
end, { desc = 'Neo-tree toggle (reveal current file)' })

return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  cmd = { 'Neotree' },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  config = function()
    local Snacks = require 'snacks'
    local events = require 'neo-tree.events'

    require('neo-tree').setup {
      filesystem = {
        follow_current_file = {
          leave_dirs_open = true,
        },
        preview = {
          enable = true,
          use_image_nvim = false,
        },
      },
      event_handlers = {
        {
          event = events.FILE_MOVED,
          handler = function(data)
            Snacks.rename.on_rename_file(data.source, data.destination)
          end,
        },
        {
          event = events.FILE_RENAMED,
          handler = function(data)
            Snacks.rename.on_rename_file(data.source, data.destination)
          end,
        },
      },
    }
  end,
}
