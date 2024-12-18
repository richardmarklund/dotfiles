vim.keymap.set('n', '<leader>bp', '<Plug>(printer_print)iw')
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
