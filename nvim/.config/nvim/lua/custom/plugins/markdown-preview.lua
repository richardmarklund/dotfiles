vim.keymap.set('n', '<leader>um', ':MarkdownPreviewToggle<CR>', { desc = 'Toggle [U]tility [M]arkdown preview' })

return {
  'iamcco/markdown-preview.nvim',
  cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
  build = 'cd app && yarn install',
  init = function()
    vim.g.mkdp_filetypes = { 'markdown' }
  end,
  ft = { 'markdown' },
}
