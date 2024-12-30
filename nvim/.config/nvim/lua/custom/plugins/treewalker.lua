vim.keymap.set({ 'n', 'v' }, '<C-S-k>', '<cmd>Treewalker Up<cr>', { noremap = true, silent = true })
vim.keymap.set({ 'n', 'v' }, '<C-S-j>', '<cmd>Treewalker Down<cr>', { noremap = true, silent = true })

return {
  'aaronik/treewalker.nvim',
  opts = {
    highlight = true, -- Whether to briefly highlight the node after jumping to it
    highlight_duration = 250, -- How long should above highlight last (in ms)
  },
}
