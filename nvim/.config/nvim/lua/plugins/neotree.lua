return {
  "nvim-neo-tree/neo-tree.nvim",
  filesystem = {
    follow_current_file = {
      enabled = false, -- This will find and focus the file in the active buffer every time
      --               -- the current file is changed while the tree is open.
    },
  },
}
