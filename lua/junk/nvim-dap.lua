return {
	"mfussenegger/nvim-dap",
	dependencies = {
		{
			-- fancy UI for the debugger
			"rcarriga/nvim-dap-ui",
			dependencies = { "nvim-neotest/nvim-nio" },

			keys = {
				{
					"<leader>du",
					function()
						require("dapui").toggle({})
					end,
					desc = "Dap UI",
				},
				{
					"<leader>de",
					function()
						require("dapui").elements.watches.add(vim.fn.expand("<cword>"))
					end,
					desc = "Watch variable",
				},
				{
					"<leader>dE",
					function()
						require("dapui").elements.watches.remove()
					end,
					desc = "Delete watch variable",
				},
			},

			opts = {},
			config = function(_, opts)
				local dap = require("dap")
				local dapui = require("dapui")
				dapui.setup(opts)
				dap.listeners.after.event_initialized.dapui_config = function()
					dapui.open({})
				end
				dap.listeners.before.event_terminated.dapui_config = function()
					dapui.close({})
				end
				dap.listeners.before.event_exited.dapui_config = function()
					dapui.close({})
				end
			end,
		},

		{
			-- virtual text for the debugger
			"theHamsta/nvim-dap-virtual-text",
			opts = {},
		},
	},

	keys = {
		{
			"<leader>dx",
			function()
				require("dap").clear_breakpoints()
			end,
			desc = "Clear breakpoints",
		},
	},

	config = function()
		if LazyVim.has("mason-nvim-dap.nvim") then
			require("mason-nvim-dap").setup(LazyVim.opts("mason-nvim-dap.nvim"))
		end
		vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
		for name, sign in pairs(LazyVim.config.icons.dap) do
			sign = type(sign) == "table" and sign or { sign }
			vim.fn.sign_define(
				"Dap" .. name,
				{ text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
			)
		end
	end,
}
