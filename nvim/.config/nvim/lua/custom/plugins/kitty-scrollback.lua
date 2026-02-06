return {
  'mikesmithgh/kitty-scrollback.nvim',
  -- Load lazily; plugin provides user commands to generate kittens
  lazy = true,
  event = 'VeryLazy',
  -- Expose likely commands for on-demand loading; event covers general use
  cmd = {
    'KittyScrollbackGenerateKittens',
    'KittyScrollbackCheckHealth',
  },
  opts = {},
}
