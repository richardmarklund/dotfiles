return {
  'andythigpen/nvim-coverage',
  version = '*',
  cmd = { 'Coverage', 'CoverageLoad', 'CoverageShow', 'CoverageSummary', 'CoverageToggle', 'CoverageClear' },
  ft = { 'go', 'javascript', 'typescript', 'python', 'java' },
  dependencies = { 'nvim-lua/plenary.nvim', 'nvim-neotest/neotest' },
  keys = { '<leader>tcc', '<leader>tcs', '<leader>tcd', '<leader>tct' },
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

    local jacoco = require 'custom.jacoco'
    jacoco.setup()

    vim.api.nvim_create_user_command('LoadCoverageSmart', function()
      if vim.bo.filetype == 'java' then
        local report, source_root = jacoco.paths()
        if not report or vim.fn.filereadable(report) == 0 then
          vim.notify('No JaCoCo report for this module. Run Maven test jacoco:report first.', vim.log.levels.WARN)
          return
        end
        require('coverage.config').opts.lang.java = { coverage_file = report, dir_prefix = source_root }
        coverage.load(true)
        return
      end
      local coverage_file = find_coverage_file()
      if coverage_file then
        local coverage_dir = vim.fn.fnamemodify(coverage_file, ':h')
        local old_dir = vim.fn.getcwd()
        vim.cmd('lcd ' .. vim.fn.fnameescape(coverage_dir))
        vim.cmd 'Coverage'
        vim.cmd('lcd ' .. vim.fn.fnameescape(old_dir))
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
