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
      vim.diagnostic.config {
        virtual_text = false, -- disable inline text
        virtual_lines = true, -- show diagnostics below the line
        signs = false, -- disable signs in the gutter
        underline = false, -- disable underlines
        update_in_insert = false, -- don’t update while typing
        severity_sort = true, -- show errors before warnings
      }
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      require('lspconfig').lua_ls.setup { capabilities = capabilities }

      -- Run goimprts after save, then it saves the new changes that go import made
      vim.api.nvim_create_autocmd('BufWritePost', {
        pattern = '*.go',
        callback = function(args)
          -- Prevent autocmd recursion
          if vim.b.goimports_formatting then
            vim.b.goimports_formatting = false
            return
          end

          local filepath = vim.api.nvim_buf_get_name(args.buf)
          local goimports = vim.fn.system('goimports ' .. vim.fn.shellescape(filepath))
          if vim.v.shell_error == 0 then
            local lines = vim.split(goimports, '\n', { plain = true })
            -- Remove trailing empty line if present (because vim.split adds an extra line for trailing NL)
            if lines[#lines] == '' then
              table.remove(lines, #lines)
            end
            local old_lines = vim.api.nvim_buf_get_lines(args.buf, 0, -1, false)
            if not vim.deep_equal(lines, old_lines) then
              vim.api.nvim_buf_set_lines(args.buf, 0, -1, false, lines)
              vim.b.goimports_formatting = true
              vim.cmd 'update' -- write changes only if buffer was changed
            end
          end
        end,
      })

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
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

          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      local servers = {
        gopls = {
          cmd = { 'gopls' },
          settings = {
            gopls = {
              gofumpt = true,
              staticcheck = true,
              verboseOutput = false,
              buildFlags = { '-tags=integration' },
              analyses = {
                unusedparams = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
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

      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        automatic_enable = true,
        ensure_installed = ensure_installed,
        automatic_installation = true,

        handlers = {
          function(server_name)
            local server_opts = servers[server_name] or {}

            -- Force proper shape and deep-merge settings + capabilities
            local opts = vim.tbl_deep_extend('force', {
              capabilities = capabilities,
              settings = {},
            }, server_opts)

            require('lspconfig')[server_name].setup(opts)
          end,
        },
      }
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
