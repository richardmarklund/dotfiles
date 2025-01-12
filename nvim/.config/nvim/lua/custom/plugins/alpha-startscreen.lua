return {
  'goolord/alpha-nvim',
  dependencies = { 'echasnovski/mini.icons' },
  config = function()
    require('alpha').setup(require('custom.plugins.alpha-dashboard').config)
  end,
}
