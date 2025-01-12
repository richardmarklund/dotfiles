vim.keymap.set('n', '<leader>hf', ':Telekasten find_notes<CR>', { desc = 'Find notes' })
vim.keymap.set('n', '<leader>hs', ':Telekasten search_notes<CR>', { desc = 'Search in notes' })
vim.keymap.set('n', '<leader>hn', ':Telekasten new_note<CR>', { desc = 'Create a new note' })
vim.keymap.set('n', '<leader>ht', ':Telekasten show_tags<CR>', { desc = 'Show tags' })

return {
  'renerocksai/telekasten.nvim',
  dependencies = { 'nvim-telescope/telescope.nvim' },
  lazy = 'true',
  event = 'VeryLazy',
  config = function()
    require('telekasten').setup {
      home = vim.fn.expand '/Volumes/notes.marklund.io/', -- Put the name of your notes directory here
    }
  end,
}
