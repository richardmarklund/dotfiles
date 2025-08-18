return {
  'adibhanna/nvim-newfile.nvim',
  dependencies = {
    'MunifTanjim/nui.nvim',
  },
  config = function()
    require('nvim-newfile').setup {}
    vim.keymap.set('n', '<leader>nf', ':NewFile<CR>', { desc = 'Create new file' })
    vim.keymap.set('n', '<leader>nh', ':NewFileHere<CR>', { desc = 'Create new file here' })
  end,
}
