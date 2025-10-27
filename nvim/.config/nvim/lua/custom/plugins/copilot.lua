return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  event = 'InsertEnter',
  opts = {
    suggestion = {
      enabled = true,
      auto_trigger = true, -- Auto trigger enabled
      hide_during_completion = true,
      debounce = 75,
      keymap = {
        accept = '<M-l>', -- Alt+l to accept inline suggestion
        accept_word = '<M-w>', -- Alt+w to accept word
        accept_line = '<M-j>', -- Alt+j to accept line
        next = '<M-]>', -- Alt+] for next suggestion
        prev = '<M-[>', -- Alt+[ for previous suggestion
        dismiss = '<C-]>', -- Ctrl+] to dismiss
      },
    },
    panel = {
      enabled = true,
      auto_refresh = false,
      keymap = {
        jump_prev = '[[',
        jump_next = ']]',
        accept = '<CR>',
        refresh = 'gr',
        open = '<M-CR>', -- Alt+Enter to open panel
      },
      layout = {
        position = 'bottom', -- | top | left | right
        ratio = 0.4,
      },
    },
    filetypes = {
      go = true,
      lua = true,
      sql = true,
      python = true,
      javascript = true,
      typescript = true,
      rust = true,
      c = true,
      cpp = true,
      java = true,
      markdown = true,
      help = true,
      gitcommit = true,
      gitrebase = true,
      hgcommit = true,
      svn = true,
      cvs = true,
      ['.'] = false,
      ['*'] = false, -- disable for all other filetypes by default
    },
    copilot_node_command = 'node', -- Node.js version must be > 18.x
    server_opts_overrides = {
      trace = 'verbose',
      settings = {
        advanced = {
          listCount = 10, -- increase list size
          inlineSuggestCount = 3, -- increase inline suggestions
        },
      },
    },
  },
}
