return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      { 'rcasia/neotest-java', dependencies = { 'mfussenegger/nvim-jdtls', 'mfussenegger/nvim-dap' } },
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      {
        'nvim-treesitter/nvim-treesitter', -- Optional, but recommended
        branch = 'main', -- NOTE; not the master branch!
        build = function()
          vim.cmd ':TSUpdate go'
        end,
      },
      {
        'fredrikaverpil/neotest-golang',
        version = '*', -- Optional, but recommended; track releases
        build = function()
          vim.system({ 'go', 'install', 'gotest.tools/gotestsum@latest' }):wait() -- Optional, but recommended
        end,
      },
    },
    keys = {
      {
        '<leader>ta',
        function()
          require('neotest').run.attach()
        end,
        desc = '[t]est [a]ttach',
      },
      {
        '<leader>tf',
        function()
          require('neotest').run.run(vim.fn.expand '%')
        end,
        desc = '[t]est run [f]ile',
      },
      {
        '<leader>tA',
        function()
          require('neotest').run.run(vim.uv.cwd())
        end,
        desc = '[t]est [A]ll files',
      },
      {
        '<leader>tS',
        function()
          require('neotest').run.run { suite = true }
        end,
        desc = '[t]est [S]uite',
      },
      {
        '<leader>tn',
        function()
          require('neotest').run.run()
        end,
        desc = '[t]est [n]earest',
      },
      {
        '<leader>tl',
        function()
          require('neotest').run.run_last()
        end,
        desc = '[t]est [l]ast',
      },
      {
        '<leader>ts',
        function()
          require('neotest').summary.toggle()
        end,
        desc = '[t]est [s]ummary',
      },
      {
        '<leader>to',
        function()
          require('neotest').output.open { enter = true, auto_close = true }
        end,
        desc = '[t]est [o]utput',
      },
      {
        '<leader>tO',
        function()
          require('neotest').output_panel.toggle()
        end,
        desc = '[t]est [O]utput panel',
      },
      {
        '<leader>tt',
        function()
          require('neotest').run.stop()
        end,
        desc = '[t]est [t]erminate',
      },
      {
        '<leader>td',
        function()
          require('neotest').run.run { strategy = 'dap' }
        end,
        desc = 'Debug nearest test',
      },
      {
        '<leader>tD',
        function()
          require('neotest').run.run { vim.fn.expand '%', strategy = 'dap' }
        end,
        desc = 'Debug current file',
      },
      {
        '<leader>tX',
        function()
          local function close_float_notifiers()
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              local ok_cfg, cfg = pcall(vim.api.nvim_win_get_config, win)
              if ok_cfg and cfg and cfg.relative and cfg.relative ~= '' then
                local ok_buf, buf = pcall(vim.api.nvim_win_get_buf, win)
                if ok_buf and buf then
                  local ft = vim.api.nvim_get_option_value('filetype', { buf = buf })
                  if ft == 'notify' or ft == 'snacks_notif' or ft == 'snacks' then
                    pcall(vim.api.nvim_win_close, win, true)
                  end
                end
              end
            end
          end

          local ok, Snacks = pcall(require, 'snacks')
          if ok then
            if Snacks.notify and Snacks.notify.dismiss then
              pcall(Snacks.notify.dismiss)
            end
            if Snacks.notifier and Snacks.notifier.hide then
              pcall(Snacks.notifier.hide)
            end
            if Snacks.notifier and Snacks.notifier.clear then
              pcall(Snacks.notifier.clear)
            end
          end
          local ok2, notify = pcall(require, 'notify')
          if ok2 and notify and notify.dismiss then
            pcall(notify.dismiss)
          end
          close_float_notifiers()
        end,
        desc = '[t]est dismiss notifications',
      },
      {
        '<leader>tF',
        function()
          require('neotest').jump.next { status = 'failed' }
        end,
        desc = '[t]est jump next failed',
      },
    },
    config = function()
      -- Command to clear any persistent notifications from Snacks/nvim-notify
      vim.api.nvim_create_user_command('GoTestDismiss', function()
        local function close_float_notifiers()
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local ok_cfg, cfg = pcall(vim.api.nvim_win_get_config, win)
            if ok_cfg and cfg and cfg.relative and cfg.relative ~= '' then
              local ok_buf, buf = pcall(vim.api.nvim_win_get_buf, win)
              if ok_buf and buf then
                local ft = vim.api.nvim_get_option_value('filetype', { buf = buf })
                if ft == 'notify' or ft == 'snacks_notif' or ft == 'snacks' then
                  pcall(vim.api.nvim_win_close, win, true)
                end
              end
            end
          end
        end

        local ok, Snacks = pcall(require, 'snacks')
        if ok then
          if Snacks.notify and Snacks.notify.dismiss then
            pcall(Snacks.notify.dismiss)
          end
          if Snacks.notifier and Snacks.notifier.hide then
            pcall(Snacks.notifier.hide)
          end
          if Snacks.notifier and Snacks.notifier.clear then
            pcall(Snacks.notifier.clear)
          end
        end
        local ok2, notify = pcall(require, 'notify')
        if ok2 and notify and notify.dismiss then
          pcall(notify.dismiss)
        end
        close_float_notifiers()
      end, {})

      require('neotest').setup {
        adapters = {
          require('custom.neotest_java').adapter(),
          require 'neotest-golang' {
            runner = 'gotestsum', -- Optional, but recommended
            warn_test_name_dupes = false,
            experimental = true,
            go_test_args = { '-count=1', '-tags=integration,watermillintegration', '-coverprofile=coverage.out' },
            ---@diagnostic disable-next-line: missing-fields
            go_list_args = { '-tags=integration,watermillintegration' },
            dap_go_opts = {
              delve = {
                build_flags = { '-tags=integration,watermillintegration' },
              },
            },
          },
        },
        consumers = {
          snacks_failures = function(client)
            client.listeners.results = function(adapter_id, results, partial)
              if not adapter_id:match '^neotest%-golang' then
                return
              end
              if partial then
                return
              end

              local all_failed = {}
              local unit_status = {} -- key -> 'passed' | 'failed'
              local parent_has_child = {} -- base -> true if any subtest observed

              local function parse_id(id)
                local base, sub = id:match '::([^:]+)::"?([^"]+)"?'
                if base then
                  return base, sub
                end
                base = id:match '::([^:]+)$'
                if base then
                  return base, nil
                end
                return nil, nil
              end

              for pos_id, result in pairs(results or {}) do
                if result.status == 'failed' then
                  table.insert(all_failed, { id = pos_id, res = result })
                end
                if result.status == 'failed' or result.status == 'passed' then
                  local base, sub = parse_id(pos_id)
                  if base then
                    if sub then
                      parent_has_child[base] = true
                      unit_status[base .. '::' .. sub] = result.status
                    else
                      unit_status[base] = result.status
                    end
                  end
                end
              end

              -- Do not return when there are no failures; we still
              -- want to show a success notification if all passed.

              local function is_leaf_id(id)
                return id:find '::.+::'
              end

              local failed = {}
              for _, item in ipairs(all_failed) do
                if is_leaf_id(item.id) then
                  table.insert(failed, item)
                end
              end
              if #failed == 0 then
                failed = all_failed
              end

              local notif_lines = {}
              local summary_lines = {}
              local function hard_wrap_line(s, maxw)
                local out = {}
                local i = 1
                local len = vim.fn.strdisplaywidth(s)
                if len <= maxw then
                  return { s }
                end
                local current = ''
                for ch in s:gmatch '.' do
                  local nexts = current .. ch
                  if vim.fn.strdisplaywidth(nexts) > maxw then
                    table.insert(out, current)
                    current = ch
                    if #out >= 2 then
                      break
                    end
                  else
                    current = nexts
                  end
                end
                if #out < 2 and current ~= '' then
                  table.insert(out, current)
                end
                return out
              end

              local function strip_ansi2(s)
                return (s or ''):gsub('\27%[[0-9;]*m', ''):gsub('%[[0-9;]*m', '')
              end

              local function parse_expected_actual(lines)
                local has_ne = false
                local expected, actual
                for _, l in ipairs(lines) do
                  local ls = strip_ansi2(l)
                  if ls:match 'Not equal:' then
                    has_ne = true
                  end
                  expected = expected or ls:match '%f[%w]expected:%s*(.+)'
                  actual = actual or ls:match '%f[%w]actual%s*:%s*(.+)'
                end
                if has_ne and (expected or actual) then
                  return expected, actual
                end
              end

              local function parse_generic_error(lines)
                for _, l in ipairs(lines) do
                  local ls = strip_ansi2(l)
                  local msg = ls:match '^%s*Error:%s*(.+)'
                  if msg and not msg:match '^Not equal:' then
                    return msg
                  end
                end
              end

              local function split_test_name(id, lines)
                local base, sub = id:match '::([^:]+)::"?([^"]+)"?'
                if base then
                  return base, sub
                end
                for _, l in ipairs(lines or {}) do
                  local ls = strip_ansi2(l)
                  local t = ls:match '^%s*Test:%s*(.+)'
                  if t then
                    local b, s = t:match '([^/]+)/(.+)$'
                    if b then
                      return b, s
                    else
                      return t, nil
                    end
                  end
                end
                return id, nil
              end

              for _, item in ipairs(failed) do
                local id = item.id
                local result = item.res

                local collected = {}
                for _, err in ipairs(result.errors or {}) do
                  local msg = strip_ansi2(err.message or '')
                  table.insert(notif_lines, msg)
                  for s in msg:gmatch '[^\n]+' do
                    table.insert(collected, s)
                  end
                end

                local out_lines = {}
                if result.output and vim.fn.filereadable(result.output) == 1 then
                  out_lines = vim.fn.readfile(result.output)
                end
                for _, l in ipairs(out_lines or {}) do
                  local line = strip_ansi2(l)
                  table.insert(collected, line)
                end

                local expected, actual = parse_expected_actual(collected)
                local generic_err = nil
                if not expected and not actual then
                  generic_err = parse_generic_error(collected)
                end
                local base, sub = split_test_name(id, collected)

                if expected or actual or generic_err or base then
                  if #summary_lines > 0 then
                    table.insert(summary_lines, '')
                  end
                  local err_line
                  if expected or actual then
                    err_line = ('Error: Not equal: expected: %s actual: %s'):format(expected or '?', actual or '?')
                  elseif generic_err then
                    err_line = ('Error: %s'):format(generic_err)
                  end
                  local test_line = ('Test: %s%s%s'):format(base or id, (sub and sub ~= '' and ' — ' or ''), (sub and sub ~= '' and sub or ''))
                  -- Compact to max 2 rows by hard-wrapping to a fixed width
                  local maxw = 87
                  local wrapped = {}
                  for _, piece in ipairs(hard_wrap_line(err_line or '', maxw)) do
                    table.insert(wrapped, piece)
                    if #wrapped >= 2 then
                      break
                    end
                  end
                  if #wrapped < 2 then
                    for _, piece in ipairs(hard_wrap_line(test_line, maxw)) do
                      table.insert(wrapped, piece)
                      if #wrapped >= 2 then
                        break
                      end
                    end
                  end
                  for _, w in ipairs(wrapped) do
                    table.insert(summary_lines, w)
                  end
                end
              end

              -- Suppress per-error notifications; we'll show one concise summary via Snacks below.

              if #summary_lines > 0 then
                local tests_total, tests_failed = 0, 0
                for key, status in pairs(unit_status) do
                  local base_only = key:match '^([^:]+)$' ~= nil
                  local base = base_only and key or key:match '^([^:]+)::'
                  if not (base_only and parent_has_child[base]) then
                    tests_total = tests_total + 1
                    if status == 'failed' then
                      tests_failed = tests_failed + 1
                    end
                  end
                end
                if tests_total == 0 then
                  tests_total = #all_failed > 0 and #all_failed or 1
                  tests_failed = #all_failed
                end
                table.insert(summary_lines, '')
                table.insert(summary_lines, ('Summary: %d/%d tests failed.'):format(tests_failed, tests_total))
                local ok_snacks, Snacks = pcall(require, 'snacks')
                local text = table.concat(summary_lines, '\n')
                if ok_snacks and Snacks.notify and Snacks.notify.error then
                  if Snacks.notify and Snacks.notify.dismiss then
                    pcall(Snacks.notify.dismiss)
                  end
                  if Snacks.notifier and Snacks.notifier.hide then
                    pcall(Snacks.notifier.hide)
                  end
                  if Snacks.notifier and Snacks.notifier.clear then
                    pcall(Snacks.notifier.clear)
                  end
                  Snacks.notify.error(text, { title = 'Go Test Failures', timeout = false })
                else
                  local ok2, notify = pcall(require, 'notify')
                  if ok2 and notify and notify.dismiss then
                    pcall(notify.dismiss)
                  end
                  vim.notify(text, vim.log.levels.ERROR, { title = 'Go Test Failures' })
                end
              else
                -- No failure summaries; if tests ran and none failed, show a happy notification
                local tests_total, tests_failed = 0, 0
                for key, status in pairs(unit_status) do
                  local base_only = key:match '^([^:]+)$' ~= nil
                  local base = base_only and key or key:match '^([^:]+)::'
                  if not (base_only and parent_has_child[base]) then
                    tests_total = tests_total + 1
                    if status == 'failed' then
                      tests_failed = tests_failed + 1
                    end
                  end
                end
                if tests_total > 0 and tests_failed == 0 then
                  local ok_snacks, Snacks = pcall(require, 'snacks')
                  local msg = 'All tests pass!'
                  if ok_snacks and Snacks.notify and Snacks.notify.info then
                    if Snacks.notify and Snacks.notify.dismiss then
                      pcall(Snacks.notify.dismiss)
                    end
                    if Snacks.notifier and Snacks.notifier.hide then
                      pcall(Snacks.notifier.hide)
                    end
                    if Snacks.notifier and Snacks.notifier.clear then
                      pcall(Snacks.notifier.clear)
                    end
                    Snacks.notify.info(msg, { title = 'Go Tests', timeout = 5000 })
                  else
                    local ok2, notify = pcall(require, 'notify')
                    if ok2 and notify and notify.dismiss then
                      pcall(notify.dismiss)
                    end
                    vim.notify(msg, vim.log.levels.INFO, { title = 'Go Tests' })
                  end
                end
              end

              -- Quickfix population disabled by request.
            end
          end,
        },
        output = {
          open_on_run = false,
        },
      }
    end,
  },
}
