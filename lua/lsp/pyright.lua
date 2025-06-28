return {
  capabilities = require 'utils.lsp'.capabilities,
  on_attach = require 'utils.lsp'.on_attach,
  root_dir = function(fname)
    return require 'lspconfig.util'.root_pattern(
          '.git'
        )(fname) or
        vim.fn.getcwd()
  end,
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "strict", -- or basic
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly", -- faster; use "workspace" for full project
        autoImportCompletions = true,
      },
    },
  },
}
