local M = {}

M.keys = function(_, keys)
  table.insert(keys,
    { "<leader>dx", function() require("dap").clear_breakpoints() end, desc = "Clear breakpoints" })
  return keys
end

M.config = function()
  require('lazyvim.plugins.extras.dap.core')[1].config()
end

return M
