return {
  -- Core Treesitter (rewrite branch)
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false, -- ← per README: do NOT lazy-load
    build = ':TSUpdate',

    config = function()
      -- Install/ensure parsers (async; see README)
      -- Tip: keep this list small & relevant
      require('nvim-treesitter').install({ 'go', 'gomod', 'lua', 'vim', 'bash', 'regex', 'vimdoc', 'http', 'json' }):wait(300000) -- optional bootstrap wait (max 5min) per README

      -- Share the http parser with .rest files used by Kulala
      pcall(vim.treesitter.language.register, 'http', 'rest')

      -- Start highlighting when filetype is set (exactly as README shows)
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'go', 'gomod', 'lua', 'vim', 'bash', 'http', 'rest' },
        callback = function()
          vim.treesitter.start()
        end,
        group = vim.api.nvim_create_augroup('TSMainStart', { clear = true }),
      })

      -- Optional: Treesitter folds/indent (see README “Supported features”)
      -- vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      -- vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    lazy = false, -- load with core so mappings are ready
    dependencies = { 'nvim-treesitter/nvim-treesitter' },

    config = function()
      -- Module setup (new API on main)
      require('nvim-treesitter-textobjects').setup {
        select = {
          lookahead = true,
          selection_modes = {
            ['@parameter.outer'] = 'v',
            ['@function.outer'] = 'V',
            ['@class.outer'] = '<c-v>',
          },
          include_surrounding_whitespace = false,
        },
        move = {
          set_jumps = true,
        },
      }

      -- Keymaps per README (call module functions)
      local select = require 'nvim-treesitter-textobjects.select'
      local move = require 'nvim-treesitter-textobjects.move'
      local rep = require 'nvim-treesitter-textobjects.repeatable_move'

      -- selections
      vim.keymap.set({ 'x', 'o' }, 'af', function()
        select.select_textobject('@function.outer', 'textobjects')
      end)
      vim.keymap.set({ 'x', 'o' }, 'if', function()
        select.select_textobject('@function.inner', 'textobjects')
      end)
      vim.keymap.set({ 'x', 'o' }, 'ac', function()
        select.select_textobject('@class.outer', 'textobjects')
      end)
      vim.keymap.set({ 'x', 'o' }, 'ic', function()
        select.select_textobject('@class.inner', 'textobjects')
      end)
      vim.keymap.set({ 'x', 'o' }, 'as', function()
        select.select_textobject('@local.scope', 'locals')
      end)

      -- movements
      vim.keymap.set({ 'n', 'x', 'o' }, ']m', function()
        move.goto_next_start('@function.outer', 'textobjects')
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, ']]', function()
        move.goto_next_start('@class.outer', 'textobjects')
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, ']o', function()
        move.goto_next_start({ '@loop.inner', '@loop.outer' }, 'textobjects')
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, ']s', function()
        move.goto_next_start('@local.scope', 'locals')
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, ']z', function()
        move.goto_next_start('@fold', 'folds')
      end)

      vim.keymap.set({ 'n', 'x', 'o' }, '[m', function()
        move.goto_previous_start('@function.outer', 'textobjects')
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, '[[', function()
        move.goto_previous_start('@class.outer', 'textobjects')
      end)

      vim.keymap.set({ 'n', 'x', 'o' }, ']M', function()
        move.goto_next_end('@function.outer', 'textobjects')
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, '][', function()
        move.goto_next_end('@class.outer', 'textobjects')
      end)

      vim.keymap.set({ 'n', 'x', 'o' }, '[M', function()
        move.goto_previous_end('@function.outer', 'textobjects')
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, '[]', function()
        move.goto_previous_end('@class.outer', 'textobjects')
      end)

      vim.keymap.set({ 'n', 'x', 'o' }, ']d', function()
        move.goto_next('@conditional.outer', 'textobjects')
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, '[d', function()
        move.goto_previous('@conditional.outer', 'textobjects')
      end)

      -- repeat last movement with ; / ,
      vim.keymap.set({ 'n', 'x', 'o' }, ';', rep.repeat_last_move_next)
      vim.keymap.set({ 'n', 'x', 'o' }, ',', rep.repeat_last_move_previous)
    end,
  },
}
