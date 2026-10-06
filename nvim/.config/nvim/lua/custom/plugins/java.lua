-- Java tooling. The jdtls client itself is started from ftplugin/java.lua,
-- which is where root and workspace resolution lives.
return {
  {
    'mfussenegger/nvim-jdtls',
    ft = 'java',
    dependencies = { 'mfussenegger/nvim-dap' },
  },
  {
    -- Spring Boot language server (sts4): application.properties/yml completion,
    -- bean and endpoint navigation, Spring annotation code actions.
    'JavaHello/spring-boot.nvim',
    main = 'spring_boot',
    ft = { 'java', 'yaml', 'jproperties' },
    dependencies = { 'mfussenegger/nvim-jdtls' },
    opts = {
      -- ls_path is left unset on purpose: setup() resolves the exec jar from the
      -- mason registry. Passing the language-server directory here would be handed
      -- straight to `java -jar` and fail.
      jdtls_name = 'jdtls',
      -- The Spring Boot LS jar is built for class file version 65, so it needs Java 21+.
      -- JAVA_HOME points at 17 for project builds, hence the explicit path.
      java_cmd = '/opt/homebrew/opt/openjdk/bin/java',
    },
    config = function(_, opts)
      require('spring_boot').setup(opts)

      -- setup() registers a FileType autocmd, but the event that loaded this plugin has
      -- already fired for the current buffer. Replay it so the first file also attaches.
      local ft = vim.bo.filetype
      if ft == 'java' or ft == 'yaml' or ft == 'jproperties' then
        pcall(vim.api.nvim_exec_autocmds, 'FileType', { group = 'spring_boot_ls', pattern = ft })
      end
    end,
  },
}
