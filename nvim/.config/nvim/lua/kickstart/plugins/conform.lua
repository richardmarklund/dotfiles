return {
  { -- Autoformat
    'stevearc/conform.nvim',
    -- Load before first save so format_on_save runs reliably
    event = { 'BufReadPre', 'BufNewFile' },
    cmd = { 'ConformInfo', 'Format', 'FormatWrite' },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable autoformat on save for Markdown files
        local ft = vim.bo[bufnr].filetype
        if ft == 'markdown' then
          return
        end
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        local lsp_format_opt
        if disable_filetypes[vim.bo[bufnr].filetype] then
          lsp_format_opt = 'never'
        else
          lsp_format_opt = 'fallback'
        end
        return {
          timeout_ms = 2000,
          lsp_format = lsp_format_opt,
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        go = { 'goimports' },
        javascript = { 'prettier' },
        html = { 'prettier' },
        telekasten = { 'prettier' },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use 'stop_after_first' to run the first available formatter from the list
        -- javascript = { "prettierd", "prettier", stop_after_first = true },
      },
      formatters = {
        prettier = {
          prepend_args = function()
            return { '--print-width', '120', '--prose-wrap', 'always' }
          end,
        },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
