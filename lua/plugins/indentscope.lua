return {
  "echasnovski/mini.indentscope",
  event = { "BufReadPost", "BufNewFile" },
  opts = function()
    return {
      char = '┊',
    }
  end,
}
