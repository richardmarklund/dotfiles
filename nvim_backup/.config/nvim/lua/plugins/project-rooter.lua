return {
  "ahmedkhalf/project.nvim",
  requires = { "neovim/nvim-lspconfig" },
  config = function()
    require("project_nvim").setup({
      manual_mode = false,
      detection_methods = { "lsp", "pattern" },
      silent_chdir = true,
      show_hidden = true,
    })
  end,
}
