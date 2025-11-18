if vim.env.PROF then
  -- example for lazy.nvim
  -- change this to the correct path for your plugin manager
  local snacks = vim.fn.stdpath 'data' .. '/lazy/snacks.nvim'
  vim.opt.rtp:append(snacks)
  require('snacks.profiler').startup {
    startup = {
      event = 'VimEnter', -- stop profiler on this event. Defaults to `VimEnter`
      -- event = "UIEnter",
      -- event = "VeryLazy",
    },
  }
end

-- Disable netrw when using Neo-tree to avoid conflicts
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Disable unused language providers to silence healthcheck warnings
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

vim.keymap.set('i', '<M-BS>', '<C-w>', { noremap = true })

--[[
====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||   KICKSTART.NVIM   ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||:Tutor              ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=====================================================================

What is Kickstart?

  Kickstart.nvim is *not* a distribution.

  Kickstart.nvim is a starting point for your own configuration.
    The goal is that you can read every line of code, top-to-bottom, understand
    what your configuration is doing, and modify it to suit your needs.

    Once you've done that, you can start exploring, configuring and tinkering to
    make Neovim your own! That might mean leaving Kickstart just the way it is for a while
    or immediately breaking it into modular pieces. It's up to you!

    If you don't know anything about Lua, I recommend taking some time to read through
    a guide. One possible example which will only take 10-15 minutes:
      - https://learnxinyminutes.com/docs/lua/

    After understanding a bit more about Lua, you can use `:help lua-guide` as a
    reference for how Neovim integrates Lua.
    - :help lua-guide
    - (or HTML version): https://neovim.io/doc/user/lua-guide.html

Kickstart Guide:

  TODO: The very first thing you should do is to run the command `:Tutor` in Neovim.

    If you don't know what this means, type the following:
      - <escape key>
      - :
      - Tutor
      - <enter key>

    (If you already know the Neovim basics, you can skip this step.)

  Once you've completed that, you can continue working through **AND READING** the rest
  of the kickstart init.lua.

  Next, run AND READ `:help`.
    This will open up a help window with some basic information
    about reading, navigating and searching the builtin help documentation.

    This should be the first place you go to look when you're stuck or confused
    with something. It's one of my favorite Neovim features.

    MOST IMPORTANTLY, we provide a keymap "<space>sh" to [s]earch the [h]elp documentation,
    which is very useful when you're not exactly sure of what you're looking for.

  I have left several `:help X` comments throughout the init.lua
    These are hints about where to find more information about the relevant settings,
    plugins or Neovim features used in Kickstart.

   NOTE: Look for lines like this

    Throughout the file. These are for you, the reader, to help you understand what is happening.
    Feel free to delete them once you know what you're doing, but they should serve as a guide
    for when you are first encountering a few different constructs in your Neovim config.

If you experience any errors while trying to install kickstart, run `:checkhealth` for more info.

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now! :)
--]]

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
require 'options'

-- [[ Basic Keymaps ]]
require 'keymaps'

-- [[ Install `lazy.nvim` plugin manager ]]
require 'lazy-bootstrap'

-- [[ Configure and install plugins ]]
require 'lazy-plugins'

vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

vim.api.nvim_set_keymap('i', '<C-S-A-S>', '', { noremap = true, silent = true })

-- vim: ts=2 sts=2 sw=2 et
vim.opt.conceallevel = 2
vim.o.tabstop = 2
vim.o.shiftwidth = 2

vim.fn.setenv('DOCKER_HOST', 'unix:///Users/ab000717/.colima/docker.sock')
vim.fn.setenv('TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE', '/var/run/docker.sock')

-- Function to toggle between a Go file and its test file
function ToggleGoTestFile()
  local file = vim.fn.expand '%:p' -- Get the current file's full path
  local new_file

  -- Check if the file ends with '_test.go' and toggle accordingly
  if file:match '_test.go$' then
    new_file = file:sub(1, -9) .. '.go' -- Strip '_test' and add '.go'
  elseif file:match '.go$' then
    new_file = file:sub(1, -4) .. '_test.go' -- Add '_test' before '.go'
  else
    print 'Not a Go file!'
    return
  end

  -- Open the corresponding file
  vim.cmd('edit ' .. new_file)
end

-- Set up the keybinding
vim.api.nvim_set_keymap('n', '<Leader>ug', ':lua ToggleGoTestFile()<CR>', { noremap = true, silent = true, desc = '[U]I [G]o test toggle' })

-- Remove default LSP keymaps that create submenus
pcall(vim.keymap.del, 'n', 'grr') -- LSP rename
pcall(vim.keymap.del, 'n', 'grn') -- LSP rename (alternative)
pcall(vim.keymap.del, 'n', 'gra') -- LSP code action
pcall(vim.keymap.del, 'n', 'gri') -- LSP implementation

-- Fallback: Built-in LSP code action in visual mode
vim.keymap.set('v', '<leader>cA', function()
  vim.lsp.buf.code_action()
end, { noremap = true, silent = true, desc = 'Code Action (builtin)' })
