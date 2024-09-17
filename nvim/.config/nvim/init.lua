-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("java").setup()
Lsp = require("lspconfig")
vim.cmd.colorscheme("catppuccin")
Lsp.jdtls.setup({})
vim.o.textwidth = 80
require("lspconfig").yamlls.setup({
  settings = {
    yaml = {
      format = {
        enable = true,
      },
      hover = true,
      completion = true,

      customTags = {
        "!fn",
        "!And",
        "!If",
        "!Not",
        "!Equals",
        "!Or",
        "!FindInMap sequence",
        "!Base64",
        "!Cidr",
        "!Ref",
        "!Ref Scalar",
        "!Sub",
        "!GetAtt",
        "!GetAZs",
        "!ImportValue",
        "!Select",
        "!Split",
        "!Join sequence",
      },
    },
  },
})
