-- LSP Plugins
return {
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
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
      'nvim-java/nvim-java',

      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      -- Allows extra capabilities provided by nvim-cmp
      'saghen/blink.cmp',
    },
    config = function()
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      require('lspconfig').lua_ls.setup { capabilities = capabilities }

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
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

          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

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
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        ensure_installed = { 'lua_ls', 'jdtls' },
        automatic_installation = true,

        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
          pyright = function()
            require('lspconfig').pyright.setup {}
          end,
          jdtls = function()
            require('java').setup {
              settings = {
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
                  format = {
                    settings = {
                      url = '/Users/ab000717/git/polo/polo-dot-files/formatter/eclipse-formatter.xml',
                    },
                  },
                  configuration = {
                    maven = {
                      globalSettings = '/Users/ab000717/.m2/settings.xml',
                      userSettings = '/Users/ab000717/.m2/settings.xml',
                    },
                  },
                  eclipse = {
                    downloadsources = true,
                  },
                  maven = {
                    downloadsources = true,
                  },
                  -- Your custom nvim-java configuration goes here
                },
              },
              workspace_cache = true,
            }

            require('lspconfig').jdtls.setup {
              settings = {
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
                  format = {
                    settings = {
                      url = '/Users/ab000717/git/polo/polo-dot-files/formatter/eclipse-formatter.xml',
                    },
                  },
                  configuration = {
                    maven = {
                      globalSettings = '/Users/ab000717/.m2/settings.xml',
                      userSettings = '/Users/ab000717/.m2/settings.xml',
                    },
                  },
                  eclipse = {
                    downloadsources = true,
                  },
                  maven = {
                    downloadsources = true,
                  },
                  -- Your custom nvim-java configuration goes here
                },
              },
              workspace_cache = true,
            }
          end,
        },
      }
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
