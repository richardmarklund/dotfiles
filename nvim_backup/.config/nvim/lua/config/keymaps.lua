-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<leader>r", "<CMD>cd ~/git/<CR>", { desc = "set root to git folder" })
vim.keymap.set("n", "<leader>jj", "<CMD>Neorg<CR>", { desc = "Open neorg" })
vim.keymap.set("n", "<leader>jr", "<CMD>Neorg return<CR>", { desc = "Return from neorg" })
