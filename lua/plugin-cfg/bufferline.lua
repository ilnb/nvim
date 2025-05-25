local M = {}

M.keys = function(_, keys)
  keys = keys or {}
  return keys
end

M.opts = function(_, opts)
  opts = opts or {}
  return opts
end

M.config = function(_, opts)
  require('lazyvim.plugins.ui')[1].config(_, opts)
end

return M
