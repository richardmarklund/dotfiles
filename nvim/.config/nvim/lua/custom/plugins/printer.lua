vim.keymap.set('n', '<leader>cp', '<Plug>(printer_print)iw', { desc = '[c]ode add [p]rint statement' })
return {
  'rareitems/printer.nvim',
  config = function()
    require('printer').setup {
      keymap = 'bp', -- Plugin doesn't have any keymaps by default
      add_to_inside = function(text)
        return string.format('%s', text)
      end,
    }
  end,
}
