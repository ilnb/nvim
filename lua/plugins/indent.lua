return {
  {
    "folke/snacks.nvim",
    opts = {
      indent = {
        scope = { enabled = false }
      },
    }
  },

  {
    "echasnovski/mini.indentscope",
    version = false,
    lazy = true,
    event = "LazyFile",
    opts = {
      symbol = "│",
      options = { try_as_border = true },
    },
  },
}
