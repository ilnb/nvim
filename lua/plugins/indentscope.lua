return {
	"nvim-mini/mini.indentscope",
	event = { "BufReadPost", "BufNewFile" },
	opts = function()
		return {
			char = "┊",
		}
	end,
}
