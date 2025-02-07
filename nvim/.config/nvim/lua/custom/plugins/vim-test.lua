return {
  'vim-test/vim-test',
  config = function()
    vim.g.test_strategy = 'wezterm'
    vim.keymap.set('n', '<leader>tn', ':TestNearest -strategy=wezterm -q<CR>', { desc = 'Test Nearest' })
    vim.keymap.set('n', '<leader>tc', ':TestClass -strategy=wezterm -q<CR>', { desc = 'Test Class' })
    vim.keymap.set('n', '<leader>tl', ':TestLast -strategy=wezterm -q<CR>', { desc = 'Test Last' })
    vim.keymap.set('n', '<leader>ts', ':TestSuit -strategy=wezterm -q<CR>', { desc = 'Test Suit' })
    vim.keymap.set('n', '<leader>tv', ':TestVisit<CR>:TestNearest  -strategy=wezterm -q<CR>', { desc = 'Test Visit' })
  end,
}
