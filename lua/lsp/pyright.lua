return {
  root_dir = function(fname)
    return require 'utils.plugins'.root_pattern(
          '.git'
        )(fname) or
        vim.fn.getcwd()
  end,
  cmd = { 'pyright-langserver', '--stdio' },
  settings = {
    python = {
      analysis = {
        typeCheckingMode = 'basic', -- or strict
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = 'openFilesOnly', -- faster; use 'workspace' for full project
        autoImportCompletions = true,
        reportMissingTypeStubs = false,
      },
    },
  },
}
