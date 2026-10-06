local ok, jdtls = pcall(require, 'jdtls')
if not ok then
  return
end

local mason = vim.fn.stdpath 'data' .. '/mason'

-- jdtls itself needs Java 21+ to run, independent of the language level a project targets.
local launcher_java = '/opt/homebrew/opt/openjdk@21/bin/java'

--- Resolve the project root.
---
--- Tier-one markers identify a reactor root unambiguously, so they win when present.
--- They are absent in ZIP exports of multi-module builds, and falling back to the nearest
--- `pom.xml` would then anchor on a submodule: one jdtls per module, no cross-module symbols.
--- So the fallback walks up to the OUTERMOST `pom.xml` instead, which is the reactor root.
local function project_root(bufnr)
  local marked = vim.fs.root(bufnr, { 'mvnw', 'gradlew', 'settings.gradle', 'settings.gradle.kts', '.git' })
  if marked then
    return marked
  end

  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == '' then
    return nil
  end

  local dir, outermost = vim.fs.dirname(name), nil
  while dir and dir ~= '/' and dir ~= vim.env.HOME do
    if vim.uv.fs_stat(dir .. '/pom.xml') or vim.uv.fs_stat(dir .. '/build.gradle') or vim.uv.fs_stat(dir .. '/build.gradle.kts') then
      outermost = dir
    end
    dir = vim.fs.dirname(dir)
  end
  return outermost
end

local root_dir = project_root(0)
if not root_dir then
  return
end

-- One workspace per root, kept outside the project. The hash keeps same-named checkouts apart.
-- Use a fresh workspace after repairing the Maven cache and removing the Nexus mirror.
local workspace = string.format('%s/jdtls/%s-%s-maven-v2', vim.fn.stdpath 'cache', vim.fn.fnamemodify(root_dir, ':t'), vim.fn.sha256(root_dir):sub(1, 8))

local function jars(pattern, reject)
  local found = vim.fn.glob(pattern, true, true)
  if not reject then
    return found
  end
  return vim.tbl_filter(function(jar)
    return not jar:match(reject)
  end, found)
end

-- Java debugging uses the debug bundle; Neotest owns test discovery and execution.
local bundles = {}
vim.list_extend(bundles, jars(mason .. '/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar'))

-- Spring Boot LS contributes its own jdtls bundles for bean and endpoint resolution.
local boot_ok, boot = pcall(require, 'spring_boot')
if boot_ok then
  vim.list_extend(bundles, boot.java_extensions())
end

local settings = {
  java = {
    completion = {
      favoriteStaticMembers = {
        'org.mockito.Mockito.when',
        'org.mockito.Mockito.any',
        'org.mockito.Mockito.then',
        'org.mockito.Mockito.verify',
        'org.junit.jupiter.api.Assertions.*',
      },
    },
    -- Project runtimes are independent of the JDK that launches JDTLS.
    configuration = {
      maven = {
        globalSettings = vim.env.HOME .. '/.m2/settings.xml',
        userSettings = vim.env.HOME .. '/.m2/settings.xml',
      },
      runtimes = {
        { name = 'JavaSE-11', path = '/opt/homebrew/opt/openjdk@11/libexec/openjdk.jdk/Contents/Home' },
        { name = 'JavaSE-17', path = '/Library/Java/JavaVirtualMachines/amazon-corretto-17.jdk/Contents/Home', default = true },
        { name = 'JavaSE-21', path = '/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home' },
      },
    },
    eclipse = { downloadSources = true },
    maven = { downloadSources = true },
    signatureHelp = { enabled = true },
    inlayHints = { parameterNames = { enabled = 'all' } },
  },
}

-- Work formatter, applied only when that checkout is present.
local formatter = vim.env.HOME .. '/git/polo/polo-dot-files/formatter/eclipse-formatter.xml'
if vim.uv.fs_stat(formatter) then
  settings.java.format = { settings = { url = formatter } }
end

local function on_attach(_, bufnr)
  local map = function(keys, fn, desc)
    vim.keymap.set('n', keys, fn, { buffer = bufnr, desc = 'Java: ' .. desc, silent = true })
  end

  map('<leader>jo', jdtls.organize_imports, '[J]ava [O]rganize imports')
  map('<leader>jv', jdtls.extract_variable, '[J]ava extract [V]ariable')
  map('<leader>jc', jdtls.extract_constant, '[J]ava extract [C]onstant')
  map('<leader>ju', jdtls.update_project_config, '[J]ava [U]pdate project config')
  map('<leader>js', jdtls.super_implementation, '[J]ava [S]uper implementation')
  vim.keymap.set('v', '<leader>jm', function()
    jdtls.extract_method(true)
  end, { buffer = bufnr, desc = 'Java: extract [M]ethod', silent = true })

  map('<leader>jt', function()
    require('neotest').run.run()
  end, '[J]ava [T]est nearest (Neotest)')
  map('<leader>jT', function()
    require('neotest').run.run(vim.api.nvim_buf_get_name(bufnr))
  end, '[J]ava [T]est class (Neotest)')

  local dap_ok, jdtls_dap = pcall(require, 'jdtls.dap')
  if dap_ok then
    pcall(jdtls.setup_dap, { hotcodereplace = 'auto', config_overrides = {} })
    pcall(jdtls_dap.setup_dap_main_class_configs)
  end

  -- Organize imports on save, matching the Go behaviour.
  local group = vim.api.nvim_create_augroup('jdtls-organize-imports', { clear = false })
  vim.api.nvim_clear_autocmds { group = group, buffer = bufnr }
  vim.api.nvim_create_autocmd('BufWritePre', {
    group = group,
    buffer = bufnr,
    callback = function()
      pcall(jdtls.organize_imports)
    end,
  })
end

local capabilities = {}
local blink_ok, blink = pcall(require, 'blink.cmp')
if blink_ok then
  capabilities = blink.get_lsp_capabilities()
end

jdtls.start_or_attach {
  name = 'jdtls',
  cmd = {
    mason .. '/bin/jdtls',
    '--java-executable',
    launcher_java,
    '-configuration',
    workspace .. '-runtime-neotest',
    '-clean',
    '-data',
    workspace,
    '--jvm-arg=-javaagent:' .. mason .. '/share/jdtls/lombok.jar',
    '--jvm-arg=-Xmx4g',
  },
  root_dir = root_dir,
  settings = settings,
  capabilities = capabilities,
  on_attach = on_attach,
  init_options = {
    bundles = bundles,
    extendedClientCapabilities = vim.tbl_deep_extend('force', jdtls.extendedClientCapabilities or {}, {
      resolveAdditionalTextEditsSupport = true,
      progressReportProvider = true,
    }),
  },
}

-- vim: ts=2 sts=2 sw=2 et
