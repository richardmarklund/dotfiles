local M = {}
local namespace = vim.api.nvim_create_namespace 'jacoco-branches'
local current_data

local function nodes(value)
  if not value then
    return {}
  end
  return value._attr and { value } or value
end

local function counters(element)
  local totals = { line = { covered = 0, missed = 0 }, branch = { covered = 0, missed = 0 } }
  for _, counter in ipairs(nodes(element.counter)) do
    local target = totals[counter._attr.type:lower()]
    if target then
      target.covered = tonumber(counter._attr.covered) or 0
      target.missed = tonumber(counter._attr.missed) or 0
    end
  end
  return totals
end

function M.paths()
  local root = vim.fs.root(0, { 'pom.xml', 'build.gradle', 'build.gradle.kts' })
  if not root then
    return nil
  end
  local report = root .. '/target/site/jacoco/jacoco.xml'
  if vim.fn.filereadable(report) == 0 then
    local gradle_report = root .. '/build/reports/jacoco/test/jacocoTestReport.xml'
    if vim.fn.filereadable(gradle_report) == 1 then
      report = gradle_report
    end
  end
  return report, root .. '/src/main/java'
end

function M.parse(xml, source_root)
  local report = assert(require('neotest.lib.xml').parse(xml).report, 'Not a JaCoCo report')
  local data = { files = {}, totals = counters(report) }
  local function packages(container)
    for _, package in ipairs(nodes(container.package)) do
      for _, source in ipairs(nodes(package.sourcefile)) do
        local filename = vim.fs.normalize(source_root .. '/' .. package._attr.name .. '/' .. source._attr.name)
        local file = { lines = {}, branches = {}, totals = counters(source) }
        for _, line in ipairs(nodes(source.line)) do
          local attr = line._attr
          local number = assert(tonumber(attr.nr), 'Invalid JaCoCo line number')
          local ci, mi = tonumber(attr.ci) or 0, tonumber(attr.mi) or 0
          local cb, mb = tonumber(attr.cb) or 0, tonumber(attr.mb) or 0
          if ci == 0 then
            file.lines[number] = 'missed'
          elseif mi > 0 or mb > 0 then
            file.lines[number] = 'partial'
          else
            file.lines[number] = 'covered'
          end
          if cb + mb > 0 then
            file.branches[number] = { covered = cb, total = cb + mb }
          end
        end
        data.files[filename] = file
      end
    end
    for _, group in ipairs(nodes(container.group)) do
      packages(group)
    end
  end
  packages(report)
  return data
end

function M.load(callback)
  local opts = require('coverage.config').opts.lang.java
  local path = require('coverage.util').get_coverage_file(opts.coverage_file)
  local ok, data = pcall(function()
    return M.parse(table.concat(vim.fn.readfile(path), '\n'), opts.dir_prefix)
  end)
  if not ok then
    vim.notify('Cannot load JaCoCo coverage: ' .. tostring(data), vim.log.levels.WARN)
    return
  end
  current_data = data
  callback(data)
end

function M.sign_list(data)
  local signs = require 'coverage.signs'
  local constructors = { covered = signs.new_covered, missed = signs.new_uncovered, partial = signs.new_partial }
  local result = {}
  for filename, file in pairs(data.files) do
    local buffer = vim.fn.bufnr(filename)
    if buffer ~= -1 then
      for line, state in pairs(file.lines) do
        result[#result + 1] = constructors[state](buffer, line)
      end
    end
  end
  return result
end

local function summary_row(totals)
  local count = totals.line.covered + totals.line.missed
  return {
    statements = count,
    missing = totals.line.missed,
    branches = totals.branch.covered + totals.branch.missed,
    partial = totals.branch.missed,
    coverage = count == 0 and 100 or totals.line.covered / count * 100,
  }
end

function M.summary(data)
  local result = { files = {}, totals = summary_row(data.totals) }
  for filename, file in pairs(data.files) do
    local row = summary_row(file.totals)
    row.filename = filename
    result.files[#result.files + 1] = row
  end
  return result
end

local function render()
  local report = require 'coverage.report'
  local visible = require('coverage.signs').is_enabled() and report.language() == 'java'
  for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buffer) then
      vim.api.nvim_buf_clear_namespace(buffer, namespace, 0, -1)
      local file = visible and current_data and current_data.files[vim.api.nvim_buf_get_name(buffer)]
      if file then
        local line_count = vim.api.nvim_buf_line_count(buffer)
        for line, branches in pairs(file.branches) do
          if line <= line_count then
            local highlight = branches.covered == branches.total and 'CoverageCovered' or (branches.covered == 0 and 'CoverageUncovered' or 'CoveragePartial')
            vim.api.nvim_buf_set_extmark(buffer, namespace, line - 1, 0, {
              virt_text = { { ('  branches: %d/%d'):format(branches.covered, branches.total), highlight } },
              virt_text_pos = 'eol',
            })
          end
        end
      end
    end
  end
end

function M.setup()
  package.loaded['coverage.languages.java'] = M
  local signs = require 'coverage.signs'
  for _, name in ipairs { 'place', 'unplace' } do
    local original = signs[name]
    signs[name] = function(...)
      original(...)
      render()
    end
  end
  local group = vim.api.nvim_create_augroup('jacoco-branches', { clear = true })
  vim.api.nvim_create_autocmd('BufEnter', {
    group = group,
    callback = function()
      if require('coverage.report').language() == 'java' and current_data and signs.is_enabled() then
        signs.place(M.sign_list(current_data))
      end
    end,
  })
end

return M
