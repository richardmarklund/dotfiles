return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000,
  event = 'VeryLazy',
  config = function()
    require('catppuccin').setup()
    vim.cmd.colorscheme 'catppuccin-mocha'
  end,
}
