vim.filetype.add({
  pattern = {
    [".*"] = {
      priority = math.huge,
      function(path, bufnr)
        local line1 = vim.filetype.getlines(bufnr, 1)
        local line2 = vim.filetype.getlines(bufnr, 2)
        if
          vim.filetype.matchregex(line1, [[^AWSTemplateFormatVersion]])
          or vim.filetype.matchregex(line1, [[AWS::Serverless-2016-10-31]])
        then
          return "yaml.cloudformation"
        elseif
          vim.filetype.matchregex(line1, [[["']AWSTemplateFormatVersion]])
          or vim.filetype.matchregex(line2, [[["']AWSTemplateFormatVersion]])
          or vim.filetype.matchregex(line1, [[AWS::Serverless-2016-10-31]])
          or vim.filetype.matchregex(line2, [[AWS::Serverless-2016-10-31]])
        then
          return "json.cloudformation"
        end
      end,
    },
  },
})
