-- NOTE: Plugins can also be configured to run Lua code when they are loaded.
--
-- This is often very useful to both group configuration, as well as handle
-- lazy loading plugins that don't need to be loaded immediately at startup.
--
-- For example, in the following configuration, we use:
--  event = 'VimEnter'
--
-- which loads which-key before all the UI elements are loaded. Events can be
-- normal autocommands events (`:help autocmd-events`).
--
-- Then, because we use the `config` key, the configuration only runs
-- after the plugin has been loaded:
--  config = function() ... end

return {
  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {
      plugins = {
        presets = {
          z = false, -- hide default z prefix (we will curate)
        },
      },
      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = vim.g.have_nerd_font,
        -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
        -- default whick-key.nvim defined Nerd Font icons, otherwise define a string table
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },

      -- Document existing key chains
      spec = {
        { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
        { '<leader>d', group = '[D]iagnostic' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>t', group = '[T]est' },
        { '<leader>g', group = '[G]it', mode = { 'n', 'v' } },
        { '<leader>a', group = '[A]i', mode = { 'n', 'v' } },
        { '<leader>f', group = '[F]ile' },
        { '<leader>u', group = '[U]I' },
        { '<leader>m', group = '[M]ulti-cursor' },

        -- Curate fold (z) help to only show the allowed ones
        { 'z', group = 'Folds', mode = { 'n' } },
        { 'za', desc = 'Toggle fold', mode = { 'n' } },
        { 'zo', desc = 'Open fold under cursor', mode = { 'n' } },
        { 'zc', desc = 'Close fold under cursor', mode = { 'n' } },
        { 'zR', desc = 'Open all folds', mode = { 'n' } },

        -- Treesitter textobjects (selection)
        { 'af', desc = 'TS: outer function', mode = { 'x', 'o' } },
        { 'if', desc = 'TS: inner function', mode = { 'x', 'o' } },
        { 'ac', desc = 'TS: outer class', mode = { 'x', 'o' } },
        { 'ic', desc = 'TS: inner class', mode = { 'x', 'o' } },
        { 'as', desc = 'TS: local scope', mode = { 'x', 'o' } },

        -- Treesitter textobjects (movement)
        { ']m', desc = 'TS: next function start', mode = { 'n', 'x', 'o' } },
        { '[m', desc = 'TS: prev function start', mode = { 'n', 'x', 'o' } },
        { ']M', desc = 'TS: next function end', mode = { 'n', 'x', 'o' } },
        { '[M', desc = 'TS: prev function end', mode = { 'n', 'x', 'o' } },
        { ';', desc = 'TS: repeat last move', mode = { 'n', 'x', 'o' } },
        { ',', desc = 'TS: repeat last move (back)', mode = { 'n', 'x', 'o' } },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
