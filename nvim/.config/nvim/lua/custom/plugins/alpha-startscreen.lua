return {
  'goolord/alpha-nvim',
  event = 'VimEnter',
  dependencies = { 'echasnovski/mini.icons' },
  config = function()
    require('alpha').setup(require('alpha.themes.startify').config)
  end,
}
