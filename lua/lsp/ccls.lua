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
  cmd = { 'ccls' },
  init_options = {
    compilationDatabaseDirectory = "build",
    index = {
      threads = 0,
    },
    clang = {
      excludeArgs = { "-frounding-math" },
    },
    cache = {
      directory = ".ccls-cache",
    },
    single_file_support = true,
  },
  filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
}
