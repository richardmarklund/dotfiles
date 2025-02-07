return {
  'saghen/blink.cmp',
  dependencies = 'rafamadriz/friendly-snippets',
  lazy = 'true',

  version = '*',
  opts = {
    sources = {
      providers = {
        lsp = {
          async = true,
        },
      },
    },
    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = 'mono',
    },
    signature = {
      enabled = true,
    },
    completion = {
      documentation = {
        auto_show = true,
      },
    },
  },
}
