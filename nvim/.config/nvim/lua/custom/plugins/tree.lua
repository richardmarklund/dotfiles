vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { desc = 'Neotree toggle' })

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
    require('neo-tree').setup({
      filesystem = {
        preview = {
          enable = true,
          use_image_nvim = false,
        },
      },
    })
  end,
}
