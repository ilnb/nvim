return {
  cmd = { 'qmlls6' },
  filetypes = { 'qml' },
  root_markers = { '.git', 'qmlls.ini' },
  settings = {
    QmlLsp = {
      import_paths = { '/usr/lib/qt/qml' },
    },
  },
}
