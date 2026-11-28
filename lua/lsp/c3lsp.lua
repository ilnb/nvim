---@type vim.lsp.Config
return {
  cmd = {
    'c3-lsp',
    '--stdlib-path=/usr/lib/c3/std',
  },
  root_markers = { 'c3lsp.json', 'project.json', 'manifest.json' },
}
