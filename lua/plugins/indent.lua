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
    event = "LazyFile",
    opts = {
      symbol = "│",
      options = { try_as_border = true },
    },
    config = function()
      require('mini.indentscope').setup({
        char = '┊',
      })
    end
  },
}
