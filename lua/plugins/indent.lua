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
    event = "VeryLazy",
    version = false,
    config = function()
      require('mini.indentscope').setup({
        char = '┊',
      })
    end
  },
}
