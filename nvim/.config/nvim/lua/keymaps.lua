-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`
-- Use `K` for LSP hover (avoid shadowing <C-a>)
vim.keymap.set('n', 'K', function()
  vim.lsp.buf.hover()
end, { desc = 'LSP Hover' })
-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps (suppress built-in floats since we use tiny-inline-diagnostic)
vim.keymap.set('n', '<leader>dq', vim.diagnostic.setloclist, { desc = '[D]iagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>dn', function() vim.diagnostic.goto_next({ float = false }) end, { desc = '[D]iagnostic [N]ext' })
vim.keymap.set('n', '<leader>dp', function() vim.diagnostic.goto_prev({ float = false }) end, { desc = '[D]iagnostic [P]revious' })

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
vim.keymap.set('n', '<leader>x', '<cmd>cd ~/dotfiles/nvim/.config/nvim/<CR>', { desc = 'cd to nvim config' })

-- Window management with leader key
vim.keymap.set('n', '<leader>wv', '<C-w>v', { desc = '[W]indow split [V]ertical' })
vim.keymap.set('n', '<leader>wh', '<C-w>s', { desc = '[W]indow split [H]orizontal' })
vim.keymap.set('n', '<leader>we', '<C-w>=', { desc = '[W]indow [E]qual size' })
vim.keymap.set('n', '<leader>wo', '<C-w>o', { desc = '[W]indow [O]nly (close others)' })
vim.keymap.set('n', '<leader>wq', '<C-w>q', { desc = '[W]indow [Q]uit' })

-- Window resizing
vim.keymap.set('n', '<leader>w+', '<C-w>+', { desc = '[W]indow height [+]' })
vim.keymap.set('n', '<leader>w-', '<C-w>-', { desc = '[W]indow height [-]' })
vim.keymap.set('n', '<leader>w>', '<C-w>>', { desc = '[W]indow width [>]' })
vim.keymap.set('n', '<leader>w<', '<C-w><', { desc = '[W]indow width [<]' })

-- Window maximize
vim.keymap.set('n', '<leader>wm', '<C-w>_<C-w>|', { desc = '[W]indow [M]aximize' })

-- Smart window movement functions that respect neotree
local function is_neotree_open()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local filetype = vim.api.nvim_buf_get_option(buf, 'filetype')
    if filetype == 'neo-tree' then
      return true, win
    end
  end
  return false, nil
end

local function smart_move_left()
  local neotree_open, neotree_win = is_neotree_open()
  
  if neotree_open then
    -- Move current window to the far left
    vim.cmd('wincmd H')
    -- Now move neotree to the far left (which pushes our window to second position)
    vim.api.nvim_set_current_win(neotree_win)
    vim.cmd('wincmd H')
    -- Focus back on our moved window (now second from left)
    vim.cmd('wincmd l')
  else
    -- Normal behavior if neotree is closed
    vim.cmd('wincmd H')
  end
end

-- Window movement (move current window)
vim.keymap.set('n', '<leader>wH', smart_move_left, { desc = '[W]indow move left (smart)' })
vim.keymap.set('n', '<leader>wL', '<C-w>L', { desc = '[W]indow move far right' })
vim.keymap.set('n', '<leader>wJ', '<C-w>J', { desc = '[W]indow move bottom' })
vim.keymap.set('n', '<leader>wK', '<C-w>K', { desc = '[W]indow move top' })

-- Enhanced text manipulation
vim.keymap.set('x', '<leader>p', '"_dP', { desc = 'Paste without yanking' })
vim.keymap.set('v', 'J', ":m '>+1<cr>gv=gv", { desc = 'Move selection down' })
vim.keymap.set('v', 'K', ":m '<-2<cr>gv=gv", { desc = 'Move selection up' })

-- Mapping for quit and save (keep defaults)
-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

vim.keymap.set('n', '<leader>ua', '<cmd>Alpha<CR>', { desc = '[U]I [A]lpha dashboard' })
vim.keymap.set('n', '<leader>us', function()
  vim.opt_local.spell = not vim.opt_local.spell:get()
end, { desc = '[U]I toggle [S]pell' })
-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    local hl = vim.hl and vim.hl.on_yank or (vim.highlight and vim.highlight.on_yank)
    if hl then
      hl()
    end
  end,
})

-- Enhanced buffer navigation
vim.keymap.set('n', '<leader>bn', '<cmd>bnext<CR>', { desc = '[B]uffer [N]ext' })
vim.keymap.set('n', '<leader>bp', '<cmd>bprev<CR>', { desc = '[B]uffer [P]revious' })
vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<CR>', { desc = '[B]uffer [D]elete' })
vim.keymap.set('n', '<leader>bl', '<cmd>buffers<CR>', { desc = '[B]uffer [L]ist' })

-- Smart search enhancements (lazy loaded)
vim.keymap.set('n', '<leader>sw', function()
  local word = vim.fn.expand('<cword>')
  vim.cmd('Telescope grep_string search=' .. word)
end, { desc = '[S]earch [W]ord under cursor' })

vim.keymap.set('n', '<leader>sW', function()
  local word = vim.fn.expand('<cWORD>')
  vim.cmd('Telescope grep_string search=' .. word)
end, { desc = '[S]earch [W]ord under cursor (WORD)' })

-- Search directories and reveal selection in Neo-tree
vim.keymap.set('n', '<leader>se', function()
  require('custom.pickers.folders').search_folders()
end, { desc = '[S]earch [E]xplorer folder (Neo-tree reveal)' })

-- Optional command to trigger the same picker
vim.api.nvim_create_user_command('SearchFolders', function()
  require('custom.pickers.folders').search_folders()
end, {})

-- Git workflow enhancements
-- Use LazyGit (<leader>l) from plugin; remove fugitive-only maps

-- Code navigation enhancements (lazy loaded)
vim.keymap.set('n', '<leader>cd', '<cmd>Telescope lsp_definitions<CR>', { desc = '[C]ode [D]efinition' })
vim.keymap.set('n', '<leader>cr', '<cmd>Telescope lsp_references<CR>', { desc = '[C]ode [R]eferences' })
vim.keymap.set('n', '<leader>ci', '<cmd>Telescope lsp_implementations<CR>', { desc = '[C]ode [I]mplementations' })

-- Quick file operations
vim.keymap.set('n', '<leader>fs', '<cmd>w<CR>', { desc = '[F]ile [S]ave' })
vim.keymap.set('n', '<leader>fq', '<cmd>wq<CR>', { desc = '[F]ile [S]ave and [Q]uit' })
vim.keymap.set('n', '<leader>fn', '<cmd>enew<CR>', { desc = '[F]ile [N]ew' })

-- vim: ts=2 sts=2 sw=2 et
