return {
  cmd = { 'asm-lsp' },
  filetypes = { 'asm', 's' },
  root_dir = function() return vim.fn.expand '~' end,
  on_attach = require 'utils.lsp'.on_attach,
  capabilities = require 'utils.lsp'.capabilities,
}
