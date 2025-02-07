return {
  event = 'VeryLazy',
  'ThePrimeagen/refactoring.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  lazy = false,
  config = function()
    require('refactoring').setup()
    vim.keymap.set('n', 'gpp', function()
      require('refactoring').debug.printf { below = false }
    end)

    -- Print var

    vim.keymap.set({ 'x', 'n' }, 'gpv', function()
      require('refactoring').debug.print_var()
    end)
    -- Supports both visual and normal mode

    vim.keymap.set('n', 'gpc', function()
      require('refactoring').debug.cleanup {}
    end)
  end,
}
