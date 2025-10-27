return {
  event = 'VeryLazy',
  'ThePrimeagen/refactoring.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  -- allow lazy loading at VeryLazy (no eager load)
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

    -- Refactors (visual selection)
    vim.keymap.set('x', '<leader>cr', function()
      require('refactoring').refactor 'Extract Function'
    end, { desc = '[C]ode [R]efactor: Extract Function' })

    vim.keymap.set('x', '<leader>cv', function()
      require('refactoring').refactor 'Extract Variable'
    end, { desc = '[C]ode extract [V]ariable' })

    -- Built-in LSP code action (visual-range) as a fallback
    vim.keymap.set('x', '<leader>cA', function()
      vim.lsp.buf.code_action()
    end, { desc = 'Code Action (builtin, visual)' })
  end,
}
