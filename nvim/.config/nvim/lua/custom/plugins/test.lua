return {
  {
    event = { 'VeryLazy' },
    'rcasia/neotest-java',
    dependencies = {
      'mfussenegger/nvim-jdtls',
      'mfussenegger/nvim-dap', -- for the debugger
      'rcarriga/nvim-dap-ui', -- recommended
      'theHamsta/nvim-dap-virtual-text', -- recommended
    },
  },
  event = { 'VeryLazy' },
  {
    'nvim-neotest/neotest',
    event = { 'VeryLazy' },
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'rcasia/neotest-java',
      -- "vim-test/vim-test",
      -- "nvim-neotest/neotest-vim-test"
    },
    config = function()
      vim.keymap.set('n', '<leader>ts', "<Esc><Cmd> lua require('neotest').run.attach()<CR>", { desc = 'Show running', noremap = true, silent = true })
      vim.keymap.set('n', '<leader>tn', "<Esc><Cmd> lua require('neotest').run.run()<CR>", { desc = 'Run Nearest Test', noremap = true, silent = true })
      vim.keymap.set(
        'n',
        '<leader>td',
        "<Esc><Cmd> lua require('neotest').run.run({strategy = 'dap'})<CR>",
        { desc = 'Run Nearest Test', noremap = true, silent = true }
      )
      vim.keymap.set('n', '<leader>tr', "<Esc><Cmd> lua require('neotest').run.run_last()<CR>", { desc = 'Rerun Test', noremap = true, silent = true })
      vim.keymap.set(
        'n',
        '<leader>tc',
        "<Esc><Cmd> lua require('neotest').run.run(vim.fn.expand('%'))<CR>",
        { desc = 'Run Class', noremap = true, silent = true }
      )
      vim.keymap.set('n', '<leader>to', "<Esc><Cmd> lua require('neotest').output.open()<CR>", { desc = 'Show output', noremap = true, silent = true })
      vim.keymap.set('n', '<leader>tO', "<Esc><Cmd> lua require('neotest').output_panel.open()<CR>", { desc = 'Open output', noremap = true, silent = true })
      vim.keymap.set('n', '<leader>ts', "<Esc><Cmd> lua require('neotest').summary.toggle()<CR>", { desc = 'Toggle summary', noremap = true, silent = true })

      require('neotest').setup {
        log_level = vim.log.levels.DEBUG,
        lazy = true,
        event = { 'VeryLazy' },
        adapters = {
          -- require('neotest-vim-test'),
          require 'neotest-java' {
            lazy = true,
            event = { 'VeryLazy' },
            ignore_wrapper = false,
          },
        },
      }
    end,
  },
}
