local M = {}

M.keys = {
  { "<leader>du", function() require("dapui").toggle({}) end,                                     desc = "Dap UI" },
  { "<leader>de", function() require('dapui').elements.watches.add(vim.fn.expand('<cword>')) end, desc = "Watch variable" },
  { "<leader>dE", function() require('dapui').elements.watches.remove() end,                      desc = "Delete watch variable" },
}

M.config = function(_, opts)
  require('lazyvim.plugins.extras.dap.core')[2].config(_, opts)
end

return M
