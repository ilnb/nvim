return {
  root_dir = function(fname)
    return require 'utils.plugins'.root_pattern(
          '.git'
        )(fname) or
        vim.fn.getcwd()
  end,
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
