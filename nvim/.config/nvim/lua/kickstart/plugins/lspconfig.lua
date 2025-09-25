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
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      require('lspconfig').lua_ls.setup { capabilities = capabilities }

      -- Formatting handled by conform.nvim (goimports)

      -- Use only conform.nvim for Go formatting/imports (goimports)

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc, noremap = true, silent = true })
          end


          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

          -- Ensure gr directly opens telescope references without submenu
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          -- Custom implementation function that auto-jumps if only one result
          map('gi', function()
            vim.lsp.buf.implementation({
              on_list = function(options)
                -- Filter out mock files
                local filtered_items = vim.tbl_filter(function(item)
                  return not string.find(string.lower(item.filename), 'mock')
                end, options.items)
                
                if #filtered_items == 0 then
                  vim.notify('No implementations found', vim.log.levels.INFO)
                  return
                elseif #filtered_items == 1 then
                  -- Jump directly to single result
                  local item = filtered_items[1]
                  vim.cmd('edit ' .. item.filename)
                  vim.api.nvim_win_set_cursor(0, {item.lnum, item.col})
                else
                  -- Use telescope for multiple results
                  -- Update options with filtered items
                  options.items = filtered_items
                  require('telescope.builtin').lsp_implementations()
                end
              end
            })
          end, '[G]oto [I]mplementation')

          map('<leader>cd', require('telescope.builtin').lsp_type_definitions, '[C]ode type [D]efinition')

          map('<leader>dS', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

          map('<leader>cs', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[C]ode workspace [S]ymbols')

          map('<leader>cn', vim.lsp.buf.rename, '[C]ode re[N]ame')

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
            map('<leader>ch', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[C]ode toggle [H]ints')
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

       require('mason-tool-installer').setup {
         ensure_installed = ensure_installed,
         auto_update = false, -- Don't auto-update on startup
         run_on_start = false, -- Don't run on startup
       }

       require('mason-lspconfig').setup {
         automatic_enable = true, -- Enable automatic enabling
         ensure_installed = {}, -- Don't auto-install on startup (keep manual)
         automatic_installation = false, -- Disable automatic installation

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

       -- Auto-setup configured servers
       for server_name, _ in pairs(servers) do
         local server_opts = servers[server_name] or {}
         local opts = vim.tbl_deep_extend('force', {
           capabilities = capabilities,
           settings = {},
         }, server_opts)

          require('lspconfig')[server_name].setup(opts)
        end

       -- Command to install LSP servers on demand
       vim.api.nvim_create_user_command('LSPInstall', function(opts)
         local server = opts.args
         if server and server ~= '' then
           require('mason.api.command').MasonInstall({ server })
           vim.notify('Installing LSP server: ' .. server, vim.log.levels.INFO)
         else
           vim.notify('Usage: :LSPInstall <server_name>', vim.log.levels.WARN)
         end
       end, { nargs = 1, desc = 'Install LSP server on demand' })

       -- Command to manually enable LSP for current buffer
       vim.api.nvim_create_user_command('LSPEnable', function()
         local bufnr = vim.api.nvim_get_current_buf()
         local filename = vim.api.nvim_buf_get_name(bufnr)
         local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')

         -- Try to find appropriate server for filetype
         local server_name = nil
         if filetype == 'lua' then
           server_name = 'lua_ls'
         elseif filetype == 'go' then
           server_name = 'gopls'
         end

         if server_name then
           local server_opts = servers[server_name] or {}
           local opts = vim.tbl_deep_extend('force', {
             capabilities = capabilities,
             settings = {},
           }, server_opts)

           require('lspconfig')[server_name].setup(opts)
           require('lspconfig')[server_name].manager:try_add_wrapper(bufnr)
           vim.notify('LSP enabled for ' .. server_name, vim.log.levels.INFO)
         else
           vim.notify('No LSP server configured for filetype: ' .. filetype, vim.log.levels.WARN)
         end
       end, { desc = 'Enable LSP for current buffer' })
     end,
   },
}
-- vim: ts=2 sts=2 sw=2 et
