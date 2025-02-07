local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

local workspace_dir = '/users/ab000717/.cache/jdtls/workspace' .. project_name
local config = {
  cmd = {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    -- '-Dlog.level=ALL',
    '-Xmx4g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens',
    'java.base/java.util=ALL-UNNAMED',
    '--add-opens',
    'java.base/java.lang=ALL-UNNAMED',
    '-javaagent:/Users/ab000717/dotfiles/jdtls/lombok/lombok.jar',
    '-jar',
    '/Users/ab000717/dotfiles/jdtls/plugins/org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar',
    '-configuration',
    '/Users/ab000717/dotfiles/jdtls/config_mac',
    '-data',
    workspace_dir,
  },

  root_dir = vim.fs.root(0, { '.git', 'mvnw', 'gradlew', 'pom.xml' }),
  settings = {
    java = {
      completion = {
        favoriteStaticMembers = {
          'org.mockito.Mockito.when',
          'org.mockito.Mockito.any',
          'org.mockito.Mockito.then',
          'org.mockito.Mockito.verify',
          'org.junit.jupiter.api.Assertions.*',
        },
      },
      format = {
        settings = {
          url = '/Users/ab000717/git/polo/polo-dot-files/formatter/eclipse-formatter.xml',
        },
      },
      configuration = {
        maven = {
          globalSettings = '/Users/ab000717/.m2/settings.xml',
          userSettings = '/Users/ab000717/.m2/settings.xml',
        },
      },
      eclipse = {
        downloadsources = true,
      },
      maven = {
        downloadsources = true,
      },
      -- Your custom nvim-java configuration goes here
    },
  },
  init_options = {
    bundles = {},
  },
}
require('jdtls').start_or_attach(config)
