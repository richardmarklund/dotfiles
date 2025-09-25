return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = 'VeryLazy',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
       ensure_installed = { 'lua', 'vim', 'vimdoc' }, -- Only essential languages on startup
       -- Autoinstall languages that are not installed
       auto_install = true,
       -- Load additional languages on demand
       sync_install = false,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
    dependencies = {},
     -- There are additional nvim-treesitter modules that you can use to interact
     -- with nvim-treesitter. You should go explore a few and see what interests you:
     --
     --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
     --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
     --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
     },

     -- Command to load additional languages on demand
     vim.api.nvim_create_user_command('TSLoadExtra', function()
       local ts = require('nvim-treesitter.configs')
       ts.setup({
         ensure_installed = { 'go', 'bash', 'c', 'diff', 'html', 'luadoc', 'query' },
       })
       vim.cmd('TSUpdate')
       vim.notify('Extra Tree-sitter languages loaded!', vim.log.levels.INFO)
     end, { desc = 'Load additional Tree-sitter languages' }),
}
-- vim: ts=2 sts=2 sw=2 et
