return {
  'aznhe21/actions-preview.nvim',
  event = 'LspAttach',
  dependencies = {
    { 'nvim-telescope/telescope.nvim', optional = true },
    { 'MunifTanjim/nui.nvim', optional = true },
    { 'folke/snacks.nvim', optional = true },
  },
  keys = {
    {
      '<leader>ca',
      function()
        require('actions-preview').code_actions()
      end,
      mode = { 'n', 'x' },
      desc = 'Code Action (preview)',
    },
  },
  opts = (function()
    -- Build opts without eagerly requiring telescope to avoid startup errors
    local opts = {
      diff = { ctxlen = 4 },
      highlight_command = {},
      backend = { 'telescope', 'snacks', 'minipick', 'nui' },
      nui = {
        dir = 'col',
        keymap = nil,
        layout = {
          position = '50%',
          size = { width = '80%', height = '90%' },
          min_width = 60,
          min_height = 15,
          relative = 'editor',
        },
        preview = {
          size = '65%',
          border = { style = 'rounded', padding = { 0, 1 } },
        },
        select = {
          size = '35%',
          border = { style = 'rounded', padding = { 0, 1 } },
        },
      },
      snacks = { layout = { preset = 'default' } },
    }

    local ok, themes = pcall(require, 'telescope.themes')
    if ok and themes and type(themes.get_dropdown) == 'function' then
      opts.telescope = vim.tbl_extend(
        'force',
        themes.get_ivy({
          layout_config = { height = 0.45, preview_width = 0.7 },
          previewer = true,
        }),
        {
          make_value = nil,
          make_make_display = nil,
        }
      )
    else
      -- Safe minimal telescope config when telescope isn't available yet
      opts.telescope = { make_value = nil, make_make_display = nil }
    end

    return opts
  end)(),
  config = function(_, opts)
    require('actions-preview').setup(opts)
  end,
}
