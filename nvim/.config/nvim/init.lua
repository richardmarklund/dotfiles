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

-- Startup time measurement
local function measure_startup()
  local start_time = vim.loop.hrtime()
  vim.api.nvim_create_autocmd('VimEnter', {
    callback = function()
      local end_time = vim.loop.hrtime()
      local startup_time = (end_time - start_time) / 1e6 -- Convert to milliseconds
      vim.notify(string.format('Startup time: %.2f ms', startup_time), vim.log.levels.INFO)
    end
  })
end

-- Initialize startup measurement
measure_startup()

-- Performance monitoring commands
vim.api.nvim_create_user_command('ProfileStart', function()
  vim.cmd('profile start profile.log')
  vim.cmd('profile func *')
  vim.cmd('profile file *')
  vim.notify('Profiling started - use :ProfileStop to finish', vim.log.levels.INFO)
end, { desc = 'Start profiling' })

vim.api.nvim_create_user_command('ProfileStop', function()
  vim.cmd('profile stop')
  vim.notify('Profile saved to profile.log', vim.log.levels.INFO)
end, { desc = 'Stop profiling' })

-- Performance optimization commands
vim.api.nvim_create_user_command('OptimizeConfig', function()
  vim.notify('Running optimization checks...', vim.log.levels.INFO)

  -- Check for unused plugins
  local lazy = require('lazy')
  local plugins = lazy.plugins()
  local unused = {}

  for _, plugin in ipairs(plugins) do
    if not plugin.loaded and not plugin.cond then
      table.insert(unused, plugin.name)
    end
  end

  if #unused > 0 then
    vim.notify('Consider lazy loading: ' .. table.concat(unused, ', '), vim.log.levels.WARN)
  else
    vim.notify('All plugins are optimized!', vim.log.levels.INFO)
  end
end, { desc = 'Check for optimization opportunities' })

-- Memory usage command
vim.api.nvim_create_user_command('MemoryUsage', function()
  local stats = vim.loop.resident_set_memory()
  local usage_mb = stats / 1024 / 1024
  vim.notify(string.format('Memory usage: %.2f MB', usage_mb), vim.log.levels.INFO)
end, { desc = 'Show memory usage' })

-- LSP log maintenance: trim oversized log file
vim.api.nvim_create_user_command('LspLogTrim', function()
  local log = vim.lsp.get_log_path()
  local stat = vim.loop.fs_stat(log)
  if not stat then
    vim.notify('LSP log not found', vim.log.levels.INFO)
    return
  end
  local ok, fh = pcall(io.open, log, 'w')
  if ok and fh then
    fh:write('')
    fh:close()
    vim.notify('LSP log truncated', vim.log.levels.INFO)
  else
    vim.notify('Failed to truncate LSP log', vim.log.levels.ERROR)
  end
end, { desc = 'Truncate LSP log file' })

-- Auto-trim log if it grows too large (50MB)
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    local log = vim.lsp.get_log_path()
    local stat = vim.loop.fs_stat(log)
    if stat and stat.size > 50 * 1024 * 1024 then
      pcall(vim.cmd, 'LspLogTrim')
    end
  end,
})

-- Your other Neovim configuration here...
-- to not show all diagnostics at the same time
-- Autosave
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

-- Utility to get visual selection
local function get_visual_selection()
  vim.cmd 'normal! "vy' -- yank visual selection into "v register
  return vim.fn.getreg 'v'
end

-- Replace visual selection with given text
local function replace_visual_selection(new_text)
  -- Get start and end of visual selection
  local start_pos = vim.fn.getpos "'<"
  local end_pos = vim.fn.getpos "'>"

  local lines = vim.split(new_text, '\n', true)
  vim.api.nvim_buf_set_lines(0, start_pos[2] - 1, end_pos[2], false, lines)
end

-- Main command
local function convert_json_to_struct()
  local selection = get_visual_selection()

  if selection == '' then
    vim.notify('No text selected', vim.log.levels.ERROR)
    return
  end

  local cmd = 'json2struct -s "' .. selection:gsub('"', '\\"') .. '"'
  if vim.fn.executable('json2struct') ~= 1 then
    vim.notify('json2struct not found in PATH', vim.log.levels.WARN)
    return
  end
  local handle = io.popen(cmd)
  local result = handle:read '*a'
  handle:close()

  if not result or result == '' then
    vim.notify('No output from json2struct', vim.log.levels.ERROR)
    return
  end

  replace_visual_selection(result)
end

vim.keymap.set('v', '<leader>cs', convert_json_to_struct, { noremap = true, silent = true, desc = 'convert json to struct' })

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
pcall(vim.keymap.del, 'n', 'grr')  -- LSP rename
pcall(vim.keymap.del, 'n', 'grn')  -- LSP rename (alternative)
pcall(vim.keymap.del, 'n', 'gra')  -- LSP code action
pcall(vim.keymap.del, 'n', 'gri')  -- LSP implementation

-- Fallback: Built-in LSP code action in visual mode
vim.keymap.set('v', '<leader>cA', function()
  vim.lsp.buf.code_action()
end, { noremap = true, silent = true, desc = 'Code Action (builtin)' })

vim.api.nvim_create_user_command('EmmaSuggest', function()
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row = cursor[1]

  -- Get all lines
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  -- Find paragraph boundaries
  local function is_blank(line)
    return line:match '^%s*$'
  end

  local start_row, end_row = row, row
  while start_row > 1 and not is_blank(lines[start_row - 1]) do
    start_row = start_row - 1
  end
  while end_row < #lines and not is_blank(lines[end_row + 1]) do
    end_row = end_row + 1
  end

  -- Extract paragraph or fallback to whole file
  local paragraph = table.concat(vim.list_slice(lines, start_row, end_row), '\n')
  if paragraph:match '^%s*$' then
    paragraph = table.concat(lines, '\n')
  end

  -- Run emma suggest
  local query = vim.fn.shellescape(paragraph)
  if vim.fn.executable('emma') ~= 1 then
    vim.notify('emma CLI not found in PATH', vim.log.levels.WARN)
    return
  end
  local output = vim.fn.systemlist('emma suggest --query ' .. query)
  vim.print(output)

  if vim.v.shell_error ~= 0 then
    vim.notify('Emma failed: ' .. table.concat(output, '\n'), vim.log.levels.ERROR)
    return
  end

  -- Display in floating window
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)

  local width = math.floor(vim.o.columns * 0.7)
  local height = math.max(1, math.min(#output, math.floor(vim.o.lines * 0.5)))

  vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = 'minimal',
    border = 'rounded',
  })
end, {})
