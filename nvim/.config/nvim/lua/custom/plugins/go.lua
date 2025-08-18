return {
  'ray-x/go.nvim',
  dependencies = { -- optional packages
    'ray-x/guihua.lua',
    'neovim/nvim-lspconfig',
    'nvim-treesitter/nvim-treesitter',
    'saghen/blink.cmp', -- ensure blink.cmp is loaded first
  },
  config = function()
    local capabilities = require('blink.cmp').get_lsp_capabilities()
    require('go').setup({
      -- Disable go.nvim's completion in favor of blink.cmp
      disable_defaults = false,
      go = 'go', -- go command, can be go[default] or go1.18beta1
      goimport = 'gopls', -- goimport command, can be gopls[default] or either goimport or goimports
      fillstruct = 'gopls', -- can be nil (use fillstruct, slower) and gopls
      gofmt = 'gofumpt', -- gofmt cmd,
      tag_transform = false, -- can be transform option("snakecase", "camelcase", etc) check gopls doc
      tag_options = 'json=omitempty', -- sets options sent to gomodifytags, i.e., json=omitempty
      gotests_template = '', -- sets gotests -template parameter (check gotests for details)
      gotests_template_dir = '', -- sets gotests -template_dir parameter (check gotests for details)
      comment_placeholder = '' , -- comment_placeholder your cool placeholder e.g. 🞤 ﯣ       😘
      icons = { breakpoint = '🔥 ', currentpos = '👉' },
      verbose = false, -- output loginf in messages
      lsp_cfg = {
        capabilities = capabilities,
        settings = {
          gopls = {
            gofumpt = true,
            staticcheck = true,
            verboseOutput = false,
            buildFlags = { '-tags=integration' },
            analyses = {
              unusedparams = true,
            },
            -- Add more gopls settings
            usePlaceholders = true,
            completeUnimported = true,
            staticcheck = true,
            matcher = 'Fuzzy',
            diagnosticsDelay = '500ms',
            symbolMatcher = 'fuzzy',
            ['local'] = '',
            gofumpt = true,
          },
        },
      },
      lsp_keymaps = true, -- set to false to disable gopls/lsp keymap
      lsp_codelens = true, -- set to false to disable codelens, true by default, you can use a function
      lsp_diag_hdlr = true, -- hook lsp diag handler
      lsp_diag_underline = true,
      lsp_diag_virtual_text = { space = 0, prefix = '' },
      lsp_diag_signs = true,
      lsp_diag_update_in_insert = false,
      lsp_document_formatting = false,
      gopls_cmd = nil, -- if you need to specify gopls path and cmd, e.g {'/home/user/lsp/gopls', '-logfile', '/var/log/gopls.log' }
      gopls_remote_auto = true, -- add -remote=auto to gopls
      dap_debug = true, -- set to false to disable dap
      dap_debug_keymap = true, -- true: use keymap for debugger defined in go/dap.lua
      dap_debug_gui = {}, -- bool|table put your dap-ui setup here set to false to disable
      dap_debug_vt = { enabled_commands = true, all_frames = true }, -- bool|table put your dap-virtual-text setup here set to false to disable
      test_runner = 'go', -- one of {`go`, `richgo`, `dlv`, `ginkgo`, `gotestsum`}
      verbose_tests = true, -- set to add verbose flag to tests
      run_in_floaterm = false, -- set to true to run in float window. :GoTermClose closes the floatterm
      trouble = false, -- true: use trouble to open quickfix
      test_efm = false, -- errorformat for quickfix, default mix mode, set to true will be efm only
    })
  end,
  event = { 'CmdlineEnter' },
  ft = { 'go', 'gomod' },
  build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
}
