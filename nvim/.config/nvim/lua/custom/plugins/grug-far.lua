return {
  {
    'MagicDuck/grug-far.nvim',
    keys = {
      {
        '<leader>srr',
        function()
          require('grug-far').open()
        end,
        desc = 'open Grug Far',
      },
      {
        '<leader>srw',
        function()
          require('grug-far').open { prefills = { search = vim.fn.expand '<cword>' } }
        end,
        desc = 'search word under cursor',
      },
      {
        '<leader>srs',
        function()
          local search = vim.fn.getreg '/'
          if search and vim.startswith(search, '\\<') and vim.endswith(search, '\\>') then
            search = '\\b' .. search:sub(3, -3) .. '\\b'
          end
          require('grug-far').open { prefills = { search = search } }
        end,
        desc = 'search from last / pattern',
      },
      {
        '<leader>sri',
        function()
          require('grug-far').open { visualSelectionUsage = 'operate-within-range' }
        end,
        mode = { 'n', 'x' },
        desc = 'operate within range (n and x modes)',
      },
      {
        '<leader>srp',
        function()
          require('grug-far').open { prefills = { paths = vim.fn.expand '%' } }
        end,
        desc = 'restrict to current file path',
      },
      {
        '<leader>srf',
        function()
          local folder = vim.fn.expand '%:p:h'
          require('grug-far').open { prefills = { paths = folder } }
        end,
        desc = 'restrict to current file folder',
      },
    },
    config = function()
      require('grug-far').setup {}
    end,
  },
}
