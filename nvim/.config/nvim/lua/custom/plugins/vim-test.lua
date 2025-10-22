return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      {
        'nvim-treesitter/nvim-treesitter', -- Optional, but recommended
        branch = 'main', -- NOTE; not the master branch!
        build = function()
          vim.cmd ':TSUpdate go'
        end,
      },
      {
        'fredrikaverpil/neotest-golang',
        version = '*', -- Optional, but recommended; track releases
        build = function()
          vim.system({ 'go', 'install', 'gotest.tools/gotestsum@latest' }):wait() -- Optional, but recommended
        end,
      },
    },
    keys = {
      {
        '<leader>ta',
        function()
          require('neotest').run.attach()
        end,
        desc = '[t]est [a]ttach',
      },
      {
        '<leader>tf',
        function()
          require('neotest').run.run(vim.fn.expand '%')
        end,
        desc = '[t]est run [f]ile',
      },
      {
        '<leader>tA',
        function()
          require('neotest').run.run(vim.uv.cwd())
        end,
        desc = '[t]est [A]ll files',
      },
      {
        '<leader>tS',
        function()
          require('neotest').run.run { suite = true }
        end,
        desc = '[t]est [S]uite',
      },
      {
        '<leader>tn',
        function()
          require('neotest').run.run()
        end,
        desc = '[t]est [n]earest',
      },
      {
        '<leader>tl',
        function()
          require('neotest').run.run_last()
        end,
        desc = '[t]est [l]ast',
      },
      {
        '<leader>ts',
        function()
          require('neotest').summary.toggle()
        end,
        desc = '[t]est [s]ummary',
      },
      {
        '<leader>to',
        function()
          require('neotest').output.open { enter = true, auto_close = true }
        end,
        desc = '[t]est [o]utput',
      },
      {
        '<leader>tO',
        function()
          require('neotest').output_panel.toggle()
        end,
        desc = '[t]est [O]utput panel',
      },
      {
        '<leader>tt',
        function()
          require('neotest').run.stop()
        end,
        desc = '[t]est [t]erminate',
      },
      {
        '<leader>td',
        function()
          require('neotest').run.run { strategy = 'dap' }
        end,
        desc = 'Debug nearest test',
      },
      {
        '<leader>tD',
        function()
          require('neotest').run.run { vim.fn.expand '%', strategy = 'dap' }
        end,
        desc = 'Debug current file',
      },
    },
    config = function()
      require('neotest').setup {
        adapters = {
          require 'neotest-golang' {
            runner = 'gotestsum', -- Optional, but recommended
            warn_test_name_dupes = false,
            experimental = true,
            go_test_args = { '-count=1', '-tags=integration,watermillintegration', '-coverprofile=coverage.out' },
            go_list_args = { '-tags=integration,watermillintegration' },
            dap_go_opts = {
              delve = {
                build_flags = { '-tags=integration,watermillintegration' },
              },
            },
          },
        },
      }
    end,
  },
}
