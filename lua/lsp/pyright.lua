return {
  cmd = { 'pyright-langserver', '--stdio' },
  filetypes = { 'python' },
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
