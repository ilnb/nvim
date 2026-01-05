local capabilities = vim.tbl_deep_extend('force', {},
  vim.lsp.protocol.make_client_capabilities(),
  require 'blink.cmp'.get_lsp_capabilities {
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = false,
        },
      },
    },
  },
  {
    offsetEncoding = { 'utf-8', 'utf-16' },
    textDocument = {
      completion = {
        editsNearCursor = true,
      },
    },
  }
)

return {
  root_markers = { 'Makefile', '.clangd', '.clang-format', '.git' },
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
  filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
}
