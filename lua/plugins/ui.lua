return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      "SmiteshP/nvim-navic",
      init = require('plugin-cfg.navic').init,
      opts = require('plugin-cfg.navic').opts
    },
    optional = true,
    init = require('plugin-cfg.lualine').init,
    opts = require('plugin-cfg.lualine').opts
  },

  {
    "echasnovski/mini.indentscope",
    event = "BufReadPost",
    opts = {
      char = '┊',
    }
  },

  {
    "SmiteshP/nvim-navic",
    init = require('plugin-cfg.navic').init,
    opts = require('plugin-cfg.navic').opts
  },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    config = require('plugin-cfg.noice').config,
    keys = require('plugin-cfg.noice').keys,
    opts = require('plugin-cfg.noice').opts
  },

  {
    "folke/snacks.nvim",
    keys = require('plugin-cfg.snacks').keys,
    opts = require('plugin-cfg.snacks').opts
  },
}
