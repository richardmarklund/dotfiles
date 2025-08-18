return {
  'jake-stewart/multicursor.nvim',
  branch = '1.0',
  config = function()
    local mc = require 'multicursor-nvim'
    mc.setup()

    local set = vim.keymap.set

    -- Line-based cursor controls
    set({ 'n', 'x' }, '<up>', function()
      mc.lineAddCursor(-1)
    end, { desc = 'Add cursor [up]' })

    set({ 'n', 'x' }, '<down>', function()
      mc.lineAddCursor(1)
    end, { desc = 'Add cursor [down]' })

    set({ 'n', 'x' }, '<leader><up>', function()
      mc.lineSkipCursor(-1)
    end, { desc = 'Skip cursor [up]' })

    set({ 'n', 'x' }, '<leader><down>', function()
      mc.lineSkipCursor(1)
    end, { desc = 'Skip cursor [down]' })

    -- Match-based cursor controls
    set({ 'n', 'x' }, '<leader>n', function()
      mc.matchAddCursor(1)
    end, { desc = 'Add cursor to [next] match' })

    set({ 'n', 'x' }, '<leader>s', function()
      mc.matchSkipCursor(1)
    end, { desc = 'Skip [next] match' })

    set({ 'n', 'x' }, '<leader>N', function()
      mc.matchAddCursor(-1)
    end, { desc = 'Add cursor to [prev] match' })

    set({ 'n', 'x' }, '<leader>S', function()
      mc.matchSkipCursor(-1)
    end, { desc = 'Skip [prev] match' })

    -- Mouse support
    set('n', '<c-leftmouse>', mc.handleMouse, { desc = 'Toggle cursor with Ctrl+Click' })
    set('n', '<c-leftdrag>', mc.handleMouseDrag, { desc = 'Drag multiple cursors (Ctrl+Drag)' })
    set('n', '<c-leftrelease>', mc.handleMouseRelease, { desc = 'Release drag (Ctrl+Release)' })

    -- Toggle cursors
    set({ 'n', 'x' }, '<c-q>', mc.toggleCursor, { desc = 'Enable/disable multicursor' })

    -- Keymap layer for active multicursor state
    mc.addKeymapLayer(function(layerSet)
      layerSet({ 'n', 'x' }, '<left>', mc.prevCursor, { desc = 'Focus [prev] cursor' })
      layerSet({ 'n', 'x' }, '<right>', mc.nextCursor, { desc = 'Focus [next] cursor' })
      layerSet({ 'n', 'x' }, '<leader>x', mc.deleteCursor, { desc = 'Delete active cursor' })
      layerSet('n', '<esc>', function()
        if not mc.cursorsEnabled() then
          mc.enableCursors()
        else
          mc.clearCursors()
        end
      end, { desc = 'Enable/clear cursors' })
    end)

    -- Highlight customization
    local hl = vim.api.nvim_set_hl
    hl(0, 'MultiCursorCursor', { reverse = true })
    hl(0, 'MultiCursorVisual', { link = 'Visual' })
    hl(0, 'MultiCursorSign', { link = 'SignColumn' })
    hl(0, 'MultiCursorMatchPreview', { link = 'Search' })
    hl(0, 'MultiCursorDisabledCursor', { reverse = true })
    hl(0, 'MultiCursorDisabledVisual', { link = 'Visual' })
    hl(0, 'MultiCursorDisabledSign', { link = 'SignColumn' })
  end,
}
