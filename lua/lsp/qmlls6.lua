return {
  cmd = { 'qmlls6' },
  filetypes = { 'qml' },
  root_markers = { 'qmlls.ini', '.git' },
  settings = {
    QmlLsp = {
      import_paths = { '/usr/lib/qt/qml' },
    },
  },
}
