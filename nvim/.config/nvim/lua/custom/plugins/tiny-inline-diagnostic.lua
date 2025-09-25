-- tiny-inline-diagnostic.nvim: Show diagnostics inline in code
return {
  'rachartier/tiny-inline-diagnostic.nvim',
  event = 'LspAttach',
  priority = 1000, -- needs to be loaded in first
  config = function()
    require('tiny-inline-diagnostic').setup({
      signs = {
        left = '',
        right = '',
        diag = '●',
        arrow = '    ',
        up_arrow = '    ',
        vertical = ' │',
        vertical_end = ' └'
      },
      hi = {
        error = 'DiagnosticError',
        warn = 'DiagnosticWarn',
        info = 'DiagnosticInfo',
        hint = 'DiagnosticHint',
        arrow = 'NonText',
        background = 'CursorLine', -- Can be a highlight or a hexadecimal color (#RRGGBB)
        mixing_color = 'None', -- Can be None or a hexadecimal color (#RRGGBB). Used to blend the background color with the diagnostic background color with another color.
      },
      blend = {
        factor = 0.27,
      },
      options = {
        -- Show the source of the diagnostic.
        show_source = false,
        
        -- Throttle the update of the diagnostic when moving cursor, in milliseconds.
        -- You can increase it if you have performance issues.
        -- Or set it to 0 to have better visuals.
        throttle = 20,
        
        -- The minimum length of the message, otherwise it will be on a new line.
        softwrap = 15,
        
        -- If multiple diagnostics are under the cursor, display all of them.
        multiple_diag_under_cursor = false,
        
        -- Enable diagnostic message on all lines.
        multilines = true,
        
        -- Show all diagnostics on the cursor line.
        all_diag_on_cursorline = true,
        
        -- Enable diagnostics on Insert mode. You should also se the `throttle` option to 0, as some LSP servers are slow to respond.
        -- It may cause some performance issues with some LSP servers.
        enable_on_insert = false,
        
        overflow = {
          -- Manage the overflow of the message.
          --    - wrap: when the message is too long, it is then displayed on multiple lines.
          --    - none: the message will not be truncated.
          --    - oneline: message will be displayed entirely on one line.
          mode = 'wrap',
        },
        
        -- Format the diagnostic message.
        -- Example:
        -- format = function(diagnostic)
        --     return diagnostic.message .. ' [' .. diagnostic.source .. ']'
        -- end,
        format = nil,
        
        -- When the cursor is on a line with a diagnostic, show the diagnostic in the buffer.
        -- If disabled, you'll need to use :lua require('tiny-inline-diagnostic').toggle() to show/hide diagnostics.
        enable = true,
        
        -- Enable it only if a LSP server is attached
        only_lsp = true,
      }
    })
  end
}
