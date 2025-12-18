return {
  cmd = { 'qmlls6' },
  filetypes = { 'qml' },
  root_dir = require 'utils.plugins'.root_pattern '.git',
  settings = {
    QmlLsp = {
      import_paths = { '/usr/lib/qt/qml' },
    },
  },
}
