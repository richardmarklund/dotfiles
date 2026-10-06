local M = {}

local function maven_settings(module)
  local directory = module
  local wrapper, version
  while directory and directory ~= vim.env.HOME do
    local pom = directory .. '/pom.xml'
    if vim.fn.filereadable(pom) == 1 then
      version = version or table.concat(vim.fn.readfile(pom), '\n'):match '<jacoco%.version>%s*([^<%s]+)%s*</jacoco%.version>'
    end
    if vim.fn.executable(directory .. '/mvnw') == 1 then
      wrapper = directory .. '/mvnw'
    end
    if vim.uv.fs_stat(directory .. '/.git') then
      break
    end
    directory = vim.fs.dirname(directory)
  end
  return wrapper or 'mvn', version
end

function M.adapter(opts)
  local adapter = require 'neotest-java'(opts or { jvm_args = { '-Xshare:off' } })
  local is_test_file = adapter.is_test_file
  adapter.is_test_file = function(path)
    return path:match '%.java$' ~= nil and is_test_file(path)
  end
  local filter_dir = adapter.filter_dir
  adapter.filter_dir = function(name, path, root)
    if name == 'target' or name == 'build' or name == 'out' then
      return false
    end
    return filter_dir(name, path, root)
  end

  local build_spec = adapter.build_spec
  adapter.build_spec = function(args)
    local spec = build_spec(args)
    if not spec or not spec.command then
      return spec
    end
    local command = spec.command
    local classpath = ''
    for _, argument in ipairs(command) do
      if argument:match '^%-%-classpath=' then
        classpath = argument:sub(13)
      end
    end
    local mockito = classpath:match '([^:]+/mockito%-core%-[%d.]+%.jar)'
    if mockito then
      local major, minor = mockito:match 'mockito%-core%-(%d+)%.(%d+)'
      if tonumber(major) > 5 or (tonumber(major) == 5 and tonumber(minor) >= 14) then
        table.insert(command, 2, '-javaagent:' .. mockito)
      end
    end
    local executable, version = maven_settings(spec.cwd)
    if version then
      local agent = vim.env.HOME .. '/.m2/repository/org/jacoco/org.jacoco.agent/' .. version .. '/org.jacoco.agent-' .. version .. '-runtime.jar'
      if vim.fn.filereadable(agent) == 1 then
        table.insert(command, 2, '-javaagent:' .. agent .. '=destfile=' .. spec.cwd .. '/target/jacoco.exec,append=false')
        spec.context.jacoco = { module = spec.cwd, executable = executable, java_home = vim.fs.dirname(vim.fs.dirname(command[1])) }
      end
    end
    return spec
  end

  local results = adapter.results
  adapter.results = function(spec, result, tree)
    local test_results = results(spec, result, tree)
    local jacoco = spec.context.jacoco
    if jacoco then
      vim.schedule(function()
        vim.system(
          { jacoco.executable, '-f', jacoco.module .. '/pom.xml', '-Dstyle.color=never', 'jacoco:report' },
          {
            cwd = jacoco.module,
            env = { JAVA_HOME = jacoco.java_home },
            text = true,
          },
          vim.schedule_wrap(function(report)
            if report.code ~= 0 then
              vim.notify('Tests finished, but JaCoCo reporting failed: ' .. (report.stderr or ''), vim.log.levels.WARN)
              return
            end
            for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
              local filename = vim.api.nvim_buf_get_name(buffer)
              if vim.api.nvim_buf_is_loaded(buffer) and filename:sub(1, #jacoco.module + 1) == jacoco.module .. '/' and vim.bo[buffer].filetype == 'java' then
                if vim.fn.exists ':LoadCoverageSmart' == 2 then
                  vim.api.nvim_buf_call(buffer, function()
                    vim.cmd 'LoadCoverageSmart'
                  end)
                end
                break
              end
            end
          end)
        )
      end)
    end
    return test_results
  end
  return adapter
end

return M
