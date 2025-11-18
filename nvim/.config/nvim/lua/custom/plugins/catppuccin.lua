return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000,
  lazy = false,
  config = function()
    require('catppuccin').setup {
      flavour = 'mocha',
      integrations = {
        treesitter = true,
        native_lsp = { enabled = true },
      },
      styles = {
        comments = { 'italic' },
        conditionals = { 'italic' },
        loops = { 'italic' },
        keywords = { 'italic' },
        functions = {},
        variables = {},
        numbers = {},
        strings = {},
        types = {},
      },
    }
    vim.cmd.colorscheme 'catppuccin'
  end,
}
