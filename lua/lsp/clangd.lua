local capabilities = vim.tbl_deep_extend('force', {},
  vim.lsp.protocol.make_client_capabilities(),
  require 'blink.cmp'.get_lsp_capabilities {
    textDocument = {
      completion = {
        completionItem =
        {
          snippetSupport = false,
        },
      },
    },
  }
)

return {
  root_dir = function(fname)
    return require 'lspconfig.util'.root_pattern(
          'Makefile',
          '.git',
          '.clang-format'
        )(fname) or
        vim.fn.getcwd()
  end,
  capabilities = capabilities,
  cmd = {
    'clangd',
    '--background-index',
    '--clang-tidy',
    '--header-insertion=iwyu',
    '--completion-style=detailed',
    '--function-arg-placeholders',
    '--fallback-style=llvm',
  },
  init_options = {
    usePlaceholders = true,
    completeUnimported = true,
    clangdFileStatus = true,
  },
}
