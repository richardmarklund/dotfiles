-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`
vim.keymap.set(
  { 'n', 'i' }, -- list of map modes it'll work in
  [[<C-a]],
  function()
    vim.lsp.buf.hover() {}
  end
)
-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>dq', vim.diagnostic.setloclist, { desc = '[D]iagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>dn', vim.diagnostic.goto_next, { desc = '[D]iagnostic [N]ext' })
vim.keymap.set('n', '<leader>dp', vim.diagnostic.goto_prev, { desc = '[D]iagnostic [P]revious' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Workspace navigation
vim.keymap.set('n', '<leader>wx', '<cmd>cd ~/dotfiles/nvim/.config/nvim/<CR>', { desc = '[W]orkspace cd to nvim' })

-- Mapping for quit and save
vim.keymap.set('n', 'wq', '<cmd>q<CR>', { desc = 'Quick for :q' })
-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

vim.keymap.set('n', '<leader>ua', '<cmd>Alpha<CR>', { desc = '[U]I [A]lpha dashboard' })
-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- vim: ts=2 sts=2 sw=2 et
