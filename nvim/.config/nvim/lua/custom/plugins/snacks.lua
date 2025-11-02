return {
  'folke/snacks.nvim',
  ---@type snacks.Config
  opts = {
    lazygit = {},
    indent = {
      -- keep defaults, configure later if needed
    },
    scope = {
      cursor = true,
      keys = {
        textobject = {
          ii = {
            cursor = true,
            linewise = true,
            desc = 'scope (inner, include edges)',
          },
          ai = {
            cursor = true,
            linewise = true,
          },
        },
      },
    },
    scroll = {
      -- keep defaults, configure later if needed
    },
    words = {
      -- keep defaults, configure later if needed
    },
    gh = {
      -- keep defaults, configure later if needed
    },
    picker = {
      sources = {
        gh_issue = {
          -- keep defaults, configure later if needed
        },
        gh_pr = {
          -- keep defaults, configure later if needed
        },
      },
      win = {
        input = {
          keys = {
            ['<C-h>'] = { 'focus_preview', mode = { 'i', 'n' } },
            ['<C-j>'] = { 'focus_list', mode = { 'i', 'n' } },
          },
        },
        list = {
          keys = {
            ['<C-h>'] = { 'focus_preview', mode = { 'n', 'i' } },
            ['<C-k>'] = { 'focus_input', mode = { 'n', 'i' } },
          },
        },
        preview = {
          keys = {
            ['<C-l>'] = { 'focus_list', mode = 'n' },
            ['<C-k>'] = { 'focus_input', mode = 'n' },
          },
        },
      },
    },
  },
  keys = {
    {
      '<leader>l',
      function()
        Snacks.lazygit.open()
      end,
      desc = 'LazyGit',
    },
    {
      '<leader>gi',
      function()
        Snacks.picker.gh_issue()
      end,
      desc = 'GitHub Issues (open)',
    },
    {
      '<leader>gI',
      function()
        Snacks.picker.gh_issue { state = 'all' }
      end,
      desc = 'GitHub Issues (all)',
    },
    {
      '<leader>gp',
      function()
        Snacks.picker.gh_pr()
      end,
      desc = 'GitHub PRs (open)',
    },
    {
      '<leader>gP',
      function()
        Snacks.picker.gh_pr { state = 'all' }
      end,
      desc = 'GitHub PRs (all)',
    },
    {
      '<leader>gM',
      function()
        Snacks.picker.git_diff {
          base = 'origin/main',
          group = true,
          layout = { preset = 'right' },
        }
      end,
      desc = 'Git diff vs main',
    },
  },
  lazy = false,
}
