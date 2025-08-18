vim.keymap.set('n', '<leader>m', ':MarkdownPreviewToggle<CR>', { desc = 'Toggle [m]arkdown preview' })

return {
  'iamcco/markdown-preview.nvim',
  cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
  build = 'cd app && yarn install',
  init = function()
    vim.g.mkdp_filetypes = { 'markdown' }
  end,
  ft = { 'markdown' },
}
