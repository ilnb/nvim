return {
	"rebelot/kanagawa.nvim",
	priority = 1000,
	config = function()
		require("kanagawa").setup({
			compile = false,
			undercurl = true, -- enable undercurls
			commentStyle = { italic = true },
			functionStyle = {},
			keywordStyle = { italic = true },
			statementStyle = { bold = true },
			typeStyle = {},
			transparent = true,
			dimInactive = false, -- dim inactive window `:h hl-NormalNC`
			terminalColors = true, -- define vim.g.terminal_color_{0,17}

			colors = {
				palette = {},
				theme = {
					all = {
						ui = {
							bg_gutter = "NONE",
							float = { bg_border = "NONE" },
						},
					},
				},
			},

			---@type fun(colors: KanagawaColorsSpec): table<string, table>
			overrides = function(colors)
				return {
					NavicText = { fg = colors.palette.fujiWhite },
					Pmenu = { bg = "NONE" },
					CursorLine = { bg = "NONE" },
					NormalFloat = { bg = "NONE" },
					FloatBorder = { bg = "NONE" },
					MiniFilesCursorLine = { link = "PmenuSel" },
					MiniFilesTitleFocused = { fg = "#F9E2AF" },
					StatusLine = { bg = "NONE" },
					TabLineFill = { bg = "NONE" },
					UfoFoldedBg = { bg = "NONE" }, -- doesn't work
					UfoPreviewWin = { bg = "#5A6FAF" }, -- same here
				}
			end,

			theme = "wave",
			background = { dark = "wave", light = "wave" },
		})
	end,
}
