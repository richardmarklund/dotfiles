return {
  'andythigpen/nvim-coverage',
  version = '*',
  config = function()
    local coverage = require 'coverage'

    local function find_coverage_file()
      local path = vim.fn.expand '%:p:h'
      local prev = ''
      while path and path ~= prev do
        local candidate = path .. '/coverage.out'
        if vim.fn.filereadable(candidate) == 1 then
          return candidate
        end
        prev = path
        path = vim.fn.fnamemodify(path, ':h')
      end
      return nil
    end
    require('coverage').setup {
      summary = {
        min_coverage = 65.0, -- minimum coverage threshold (used for highlighting)
      },
      auto_reload = true,
    }

    vim.api.nvim_create_user_command('LoadCoverageSmart', function()
      local coverage_file = find_coverage_file()
      if coverage_file then
        local coverage_dir = vim.fn.fnamemodify(coverage_file, ':h')
        local old_dir = vim.fn.getcwd()
        vim.cmd('lcd ' .. coverage_dir)
        vim.cmd 'Coverage'
        vim.cmd('lcd ' .. old_dir)
        vim.cmd 'CoverageShow'
      else
        vim.notify('No coverage.out found', vim.log.levels.WARN)
      end
    end, {})
    -- Keybindings
    vim.keymap.set('n', '<leader>tcc', '<cmd>LoadCoverageSmart<CR>', { desc = '[t]est [c]overage [c]ustom load' })
    vim.keymap.set('n', '<leader>tcs', '<cmd>CoverageSummary<CR>', { desc = '[t]est [c]overage [s]ummary' })
    vim.keymap.set('n', '<leader>tcd', '<cmd>CoverageClear<CR>', { desc = '[t]est [c]overage [d]elete/clear' })
    vim.keymap.set('n', '<leader>tct', '<cmd>CoverageToggle<CR>', { desc = '[t]est [c]overage [t]oggle' })
  end,
}
