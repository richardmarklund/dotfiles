-- LSP Plugins
return {
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    event = 'VeryLazy',
    lazy = 'true',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },
  { 'Bilal2453/luvit-meta', lazy = true },
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    event = 'VeryLazy',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'danarth/sonarlint.nvim',
      'andythigpen/nvim-coverage',

      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      -- Allows extra capabilities provided by nvim-cmp
      'saghen/blink.cmp',
    },
    config = function()
      -- Diagnostics: disable built-in virtual_text and floats (handled by tiny-inline-diagnostic),
      -- but keep visible hints via signs/underline and update while typing.
      vim.diagnostic.config {
        virtual_text = false,
        virtual_lines = false,
        signs = true,
        underline = true,
        update_in_insert = true,
        severity_sort = true,
        float = false, -- Disable floating diagnostic windows
      }
      local Snacks = require 'snacks'
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      local configure_server = function(server_name, opts)
        vim.lsp.config(server_name, opts)
        vim.lsp.enable(server_name)
      end
      -- Enable LSP-powered folding (used by gopls and others)
      capabilities.textDocument = capabilities.textDocument or {}
      capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }
      configure_server('lua_ls', { capabilities = capabilities })

      -- Formatting handled by conform.nvim (gofumpt)

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc, noremap = true, silent = true })
          end

          map('gd', Snacks.picker.lsp_definitions, '[G]oto [D]efinition')

          -- Ensure gr directly opens picker references without submenu
          map('gr', Snacks.picker.lsp_references, '[G]oto [R]eferences')

          -- Implementations: filter out mock files and auto-confirm single hits
          map('gI', function()
            Snacks.picker.lsp_implementations {
              filter = {
                filter = function(item)
                  local path = item.file or item.filename
                  return not (path and string.find(string.lower(path), 'mock'))
                end,
              },
            }
          end, '[G]oto [I]mplementation')

          map('<leader>cd', Snacks.picker.lsp_type_definitions, '[C]ode type [D]efinition')

          map('<leader>dS', Snacks.picker.lsp_symbols, '[D]ocument [S]ymbols')

          map('<leader>cs', Snacks.picker.lsp_workspace_symbols, '[C]ode workspace [S]ymbols')

          map('<leader>cn', vim.lsp.buf.rename, '[C]ode re[N]ame')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>ch', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[C]ode toggle [H]ints')
          end

          if client and client.name == 'gopls' then
            local go_imports_group = vim.api.nvim_create_augroup('kickstart-go-organize-imports', { clear = false })
            vim.api.nvim_clear_autocmds { group = go_imports_group, buffer = event.buf }
            vim.api.nvim_create_autocmd('BufWritePre', {
              group = go_imports_group,
              buffer = event.buf,
              callback = function()
                vim.lsp.buf.code_action {
                  context = { only = { 'source.organizeImports' } },
                  apply = true,
                  async = false,
                }
              end,
            })
          end
        end,
      })

      -- Prefer a user/system-installed cucumber-language-server if present
      local function is_exec(p)
        return p and p ~= '' and (vim.uv.fs_access(p, 'X') or vim.fn.executable(p) == 1)
      end

      local function global_bin(tool, args)
        local ok, out = pcall(vim.fn.systemlist, vim.list_extend({ tool }, args or {}))
        if ok and out and #out > 0 then
          return (out[1] or '')
        end
        return ''
      end

      local function find_cucumber_ls()
        -- 1) Explicit env override
        local from_env = vim.env.CUCUMBER_LANGUAGE_SERVER or vim.env.CUCUMBER_LS
        if is_exec(from_env) then
          return { from_env, '--stdio' }
        end

        -- 2) PATH discovery
        local exepath = vim.fn.exepath 'cucumber-language-server'
        if is_exec(exepath) then
          return { exepath, '--stdio' }
        end

        -- 3) npm/pnpm/yarn global bins
        local npm_bin = global_bin('npm', { 'bin', '-g' })
        if is_exec(npm_bin .. '/cucumber-language-server') then
          return { npm_bin .. '/cucumber-language-server', '--stdio' }
        end
        local pnpm_bin = global_bin('pnpm', { 'bin', '-g' })
        if is_exec(pnpm_bin .. '/cucumber-language-server') then
          return { pnpm_bin .. '/cucumber-language-server', '--stdio' }
        end
        local yarn_bin = global_bin('yarn', { 'global', 'bin' })
        if is_exec(yarn_bin .. '/cucumber-language-server') then
          return { yarn_bin .. '/cucumber-language-server', '--stdio' }
        end

        -- 4) Defer to project-local detection in on_new_config
        return nil
      end

      local servers = {
        gopls = {
          cmd = { 'gopls' },
          settings = {
            gopls = {
              gofumpt = true,
              staticcheck = true,
              verboseOutput = false,
              buildFlags = { '-tags=integration,watermillintegration' },
              analyses = {
                unusedparams = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
            },
          },
        },
        ts_ls = {
          filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx' },
          root_dir = function(fname)
            local util = require 'lspconfig.util'
            return util.root_pattern('tsconfig.json', 'jsconfig.json', 'package.json', '.git')(fname)
          end,
          single_file_support = true,
        },
        -- Cucumber/Gherkin LSP (supports Godog step discovery)
        cucumber_language_server = {
          -- Use system/global/local binary if available
          cmd = find_cucumber_ls(),
          -- Neovim typically uses 'gherkin' or 'cucumber' for *.feature
          filetypes = { 'gherkin', 'cucumber' },
          root_dir = function(fname)
            local util = require 'lspconfig.util'
            local path = util.path

            -- Prefer the Godog tester module root if present
            local tester_root = util.search_ancestors(fname, function(dir)
              local has_features = path.is_dir(path.join(dir, 'cmd', 'features'))
              local has_steps = path.is_dir(path.join(dir, 'internal', 'steps'))
              if has_features or has_steps then
                return dir
              end
            end)

            -- Only start when inside a tester-style cucumber project
            if tester_root then
              return tester_root
            end

            -- No suitable root found: do not start for this file
            return nil
          end,
          single_file_support = false,
          on_new_config = function(config, root)
            if config.cmd and #config.cmd > 0 then
              return
            end
            if not root or root == '' then
              return
            end
            local local_bin = root .. '/node_modules/.bin/cucumber-language-server'
            if is_exec(local_bin) then
              config.cmd = { local_bin, '--stdio' }
            end
          end,
          -- The Cucumber LS expects initializationOptions for features/glue
          init_options = {
            cucumber = {
              -- Point to your features and Godog step definitions
              features = { 'cmd/features/**/*.feature' },
              glue = {
                'internal/steps/**/*.go',
              },
            },
          },
          -- Also provide settings so you can see them in :LspInfo
          settings = {
            cucumber = {
              features = { 'cmd/features/**/*.feature' },
              glue = { 'internal/steps/**/*.go' },
            },
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
      }

      require('mason').setup()

      local ensure_installed = vim.tbl_keys(servers or {})

      require('mason-tool-installer').setup {
        ensure_installed = ensure_installed,
        auto_update = false, -- Don't auto-update on startup
        run_on_start = false, -- Don't run on startup
      }

      require('mason-lspconfig').setup {
        -- jdtls is started per-buffer from ftplugin/java.lua, which resolves the Maven
        -- reactor root. Letting mason enable it too would start a second, wrongly rooted client.
        automatic_enable = { exclude = { 'jdtls' } },
        ensure_installed = {}, -- Don't auto-install on startup (keep manual)
        automatic_installation = false, -- Disable automatic installation

        handlers = {
          function(server_name)
            -- Skip servers we set up manually to avoid duplicates
            if server_name == 'cucumber_language_server' or server_name == 'gopls' or server_name == 'ts_ls' then
              return
            end

            local server_opts = servers[server_name] or {}

            -- Force proper shape and deep-merge settings + capabilities
            local opts = vim.tbl_deep_extend('force', {
              capabilities = capabilities,
              settings = {},
            }, server_opts)

            configure_server(server_name, opts)
          end,
        },
      }

      -- Manual setup for cucumber_language_server so our init_options/root_dir apply
      do
        local server_opts = servers['cucumber_language_server'] or {}
        local opts = vim.tbl_deep_extend('force', {
          capabilities = capabilities,
          settings = {},
        }, server_opts)
        configure_server('cucumber_language_server', opts)
      end

      -- Manual setup for gopls (installed outside Mason)
      do
        local server_opts = servers['gopls'] or {}
        local opts = vim.tbl_deep_extend('force', {
          capabilities = capabilities,
          settings = {},
        }, server_opts)
        configure_server('gopls', opts)
      end

      -- Manual setup for ts_ls so JavaScript/TypeScript always attach consistently
      do
        local server_opts = servers['ts_ls'] or {}
        local opts = vim.tbl_deep_extend('force', {
          capabilities = capabilities,
          settings = {},
        }, server_opts)
        configure_server('ts_ls', opts)
      end

      -- Command to install LSP servers on demand
      vim.api.nvim_create_user_command('LSPInstall', function(opts)
        local server = opts.args
        if server and server ~= '' then
          require('mason.api.command').MasonInstall { server }
          vim.notify('Installing LSP server: ' .. server, vim.log.levels.INFO)
        else
          vim.notify('Usage: :LSPInstall <server_name>', vim.log.levels.WARN)
        end
      end, { nargs = 1, desc = 'Install LSP server on demand' })

      -- Command to manually enable LSP for current buffer
      vim.api.nvim_create_user_command('LSPEnable', function()
        local bufnr = vim.api.nvim_get_current_buf()
        local filetype = vim.bo[bufnr].filetype

        -- Try to find appropriate server for filetype
        local server_name = nil
        if filetype == 'lua' then
          server_name = 'lua_ls'
        elseif filetype == 'go' then
          server_name = 'gopls'
        elseif filetype == 'javascript' or filetype == 'javascriptreact' or filetype == 'typescript' or filetype == 'typescriptreact' then
          server_name = 'ts_ls'
        end

        if server_name then
          local server_opts = servers[server_name] or {}
          local opts = vim.tbl_deep_extend('force', {
            capabilities = capabilities,
            settings = {},
          }, server_opts)

          configure_server(server_name, opts)
          vim.notify('LSP enabled for ' .. server_name, vim.log.levels.INFO)
        else
          vim.notify('No LSP server configured for filetype: ' .. filetype, vim.log.levels.WARN)
        end
      end, { desc = 'Enable LSP for current buffer' })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
