return {
  'mg979/vim-visual-multi',
  branch = 'master',
  init = function()
    -- Configure vim-visual-multi settings
    vim.g.VM_theme = 'iceblue'
    vim.g.VM_highlight_matches = 'hi! Search ctermfg=red'
    
    -- Key mappings
    vim.g.VM_maps = {
      ['Find Under'] = '<Leader>ma',         -- Select word under cursor
      ['Find Subword Under'] = '<Leader>ma', -- Select subword under cursor
      ['Select All'] = '<Leader>mA',         -- Select all occurrences
      ['Start Regex Search'] = '<Leader>mr', -- Start regex search
      ['Add Cursor Down'] = '<C-Down>',      -- Add cursor down
      ['Add Cursor Up'] = '<C-Up>',          -- Add cursor up
      ['Add Cursor At Pos'] = '<C-LeftMouse>', -- Click to add cursor
      
      -- Important exit keys
      ['Exit'] = '<Esc>',                    -- Exit with Esc
      ['Remove Region'] = 'q',               -- Remove current region
      ['Skip Region'] = '<Tab>',             -- Skip current region
    }
  end,
}
