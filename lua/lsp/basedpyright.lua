return {
  cmd = { 'basedpyright-langserver', '--stdio' },
  filetypes = { 'python' },
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = 'standard',
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = 'openFilesOnly', -- faster; use 'workspace' for full project
        autoImportCompletions = true,
        reportMissingTypeStubs = false,
      },
    },
  },
}
