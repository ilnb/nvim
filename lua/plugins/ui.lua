return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      {
        "SmiteshP/nvim-navic",
        config = function() require('plugin-cfg.navic').setup() end,
      }
    },
    config = function() require('plugin-cfg.lualine').setup() end,
  },

  {
    "echasnovski/mini.indentscope",
    event = "BufReadPost",
    opts = function()
      return {
        char = '┊',
      }
    end,
  },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    keys = require('plugin-cfg.noice').keys,
    opts = require('plugin-cfg.noice').opts,
    config = function(_, opts)
      require('plugin-cfg.noice').config(_, opts)
    end,
  },

  {
    "folke/snacks.nvim",
    keys = require('plugin-cfg.snacks').keys,
    opts = require('plugin-cfg.snacks').opts,
  },
}
