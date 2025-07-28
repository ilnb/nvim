return {
  cmd = { 'asm-lsp' },
  filetypes = 'asm',
  root_dir = function() return vim.fn.expand '~' end,
}
