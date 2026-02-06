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
    notifier = {
      -- keep defaults, configure later if needed
    },
    gh = {
      -- keep defaults, configure later if needed
    },
    picker = {
      ui_select = true,
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
      '<leader>sh',
      function()
        Snacks.picker.help()
      end,
      desc = '[S]earch [H]elp',
    },
    {
      '<leader>sk',
      function()
        Snacks.picker.keymaps()
      end,
      desc = '[S]earch [K]eymaps',
    },
    {
      '<leader>sf',
      function()
        Snacks.picker.files()
      end,
      desc = '[S]earch [F]iles',
    },
    {
      '<leader>ss',
      function()
        Snacks.picker.pickers()
      end,
      desc = '[S]earch [S]ources',
    },
    {
      '<leader>sw',
      function()
        Snacks.picker.grep_word()
      end,
      desc = '[S]earch current [W]ord',
    },
    {
      '<leader>sg',
      function()
        Snacks.picker.grep()
      end,
      desc = '[S]earch by [G]rep (live)',
    },
    {
      '<leader>sG',
      function()
        Snacks.picker.lines { filter = { buf = true }, layout = { preset = 'ivy' }, win = { preview = { hidden = true } } }
      end,
      desc = '[S]earch current buffer',
    },
    {
      '<leader>sd',
      function()
        Snacks.picker.diagnostics()
      end,
      desc = '[S]earch [D]iagnostics',
    },
    {
      '<leader>sr',
      function()
        Snacks.picker.resume()
      end,
      desc = '[S]earch [R]esume',
    },
    {
      '<leader>s.',
      function()
        Snacks.picker.recent()
      end,
      desc = '[S]earch Recent Files',
    },
    {
      '<leader>sb',
      function()
        Snacks.picker.buffers()
      end,
      desc = '[S]earch [B]uffers',
    },
    {
      '<leader>/',
      function()
        Snacks.picker.lines { filter = { buf = true }, layout = { preset = 'ivy' }, win = { preview = { hidden = true } } }
      end,
      desc = '[/] Fuzzily search in current buffer',
    },
    {
      '<leader>s/',
      function()
        Snacks.picker.grep_buffers { prompt = 'Live Grep (open buffers)' }
      end,
      desc = '[S]earch [/] in Open Files',
    },
    {
      '<leader>sn',
      function()
        Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
      end,
      desc = '[S]earch [N]eovim files',
    },
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
    {
      '<leader>gs',
      function()
        Snacks.picker.git_status()
      end,
      desc = 'Git status (picker)',
    },
    {
      '<leader>gf',
      function()
        Snacks.picker.git_files()
      end,
      desc = 'Git tracked files',
    },
    {
      '<leader>gc',
      function()
        Snacks.picker.git_log()
      end,
      desc = 'Git commits (repo)',
    },
    {
      '<leader>gC',
      function()
        Snacks.picker.git_log_file()
      end,
      desc = 'Git commits (current buffer)',
    },
  },
  lazy = false,
}
