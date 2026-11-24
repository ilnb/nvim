---@type vim.lsp.Config
return {
  cmd = {
    'c3-lsp',
    -- NOTE: -stdlib-path expects the *directory containing* std/, not std/ itself.
    '-stdlib-path', vim.fn.expand '~/opt/c3-lsp/assets/c3c/lib',
  },
  root_markers = { 'c3lsp.json', 'project.json', 'manifest.json' },
}
