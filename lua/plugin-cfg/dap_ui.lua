local M = {}

M.keys = {
  { "<leader>du", function() require("dapui").toggle({}) end,                                     desc = "Dap UI" },
  { "<leader>de", function() require('dapui').elements.watches.add(vim.fn.expand('<cword>')) end, desc = "Watch variable" },
  { "<leader>dE", function() require('dapui').elements.watches.remove() end,                      desc = "Delete watch variable" },
}

M.opts = {}

M.config = function(_, opts)
  local dap = require("dap")
  local dapui = require("dapui")
  dapui.setup(opts)
  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open({})
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close({})
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close({})
  end
end

return M
