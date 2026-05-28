---@type vim.lsp.Config
return {
  cmd = { 'qmlls6' },
  root_markers = { 'qmlls.ini' },
  settings = {
    QmlLsp = {
      import_paths = { '/usr/lib/qt/qml' },
    },
  },
}
