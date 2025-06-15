local M  = {}

M.keys   = function(_, keys)
  return keys
end

M.opts   = function(_, opts)
  opts.windows.max_number = 4
  return opts
end

M.config = function(_, opts)
  require('lazyvim.plugins.extras.editor.mini-files').config(_, opts)
end

return M
