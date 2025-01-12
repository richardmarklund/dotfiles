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
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>dn', vim.diagnostic.goto_next, { desc = 'Go to [d]iagnostic [n]ext' })
vim.keymap.set('n', '<leader>dp', vim.diagnostic.goto_next, { desc = 'Go to [d]iagnostic [p]revious' })

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

-- Open preview
vim.keymap.set('n', 'gp', "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", { noremap = true })

-- Quick terminal navigation
vim.keymap.set('n', '<leader>xg', '<cmd>cd ~/git<CR>', { desc = 'Change dir to git' })
vim.keymap.set('n', '<leader>xp', '<cmd>cd ~/git/polo/<CR>', { desc = 'Change dir to polorepos' })
vim.keymap.set('n', '<leader>xr', '<cmd>cd ~/git/remote-status/<CR>', { desc = 'Change dir to remote status' })
vim.keymap.set('n', '<leader>xu', '<cmd>cd ~/git/rlu/<CR>', { desc = 'Change dir to rlu' })
vim.keymap.set('n', '<leader>xh', '<cmd>cd ~/git/rhf/<CR>', { desc = 'Change dir to rhf' })
vim.keymap.set('n', '<leader>xs', '<cmd>cd ~/git/rs/<CR>', { desc = 'Change dir to rs' })
vim.keymap.set('n', '<leader>xn', '<cmd>cd ~/dotfiles/nvim/.config/nvim/<CR>', { desc = 'Change dir to nvim' })

-- Mapping for quit and save
vim.keymap.set('n', 'wq', '<cmd>q<CR>', { desc = 'Quick for :q' })
-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

vim.keymap.set('n', '<leader>a', '<cmd>Alpha<CR>', { desc = 'Go to dashboard' })
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

vim.keymap.set('n', '<leader>o', '<cmd>Oil<CR>', { desc = 'Open [o]il' })

-- vim: ts=2 sts=2 sw=2 et
