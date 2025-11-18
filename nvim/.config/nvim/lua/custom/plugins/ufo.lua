return {
  "kevinhwang91/nvim-ufo",
  dependencies = { "kevinhwang91/promise-async" },
  event = "BufReadPost",
  init = function()
    vim.o.foldcolumn = "1"
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
    vim.opt.fillchars:append({ fold = " ", foldopen = "", foldclose = "", foldsep = " " })
  end,
  opts = {
    provider_selector = function(_, _)
      return { "lsp", "indent" }
    end,
  },
  keys = {
    { "zR", function() require("ufo").openAllFolds() end, desc = "Open all folds" },
  },
}
