return {
  {
    "akinsho/bufferline.nvim",
    -- event = "VeryLazy",
    keys = function(_, keys)
      return require('plugin-cfg.bufferline').keys(_, keys)
    end,
    opts = function(_, opts)
      return require('plugin-cfg.bufferline').opts(_, opts)
    end,
  },

  {
    "ibhagwan/fzf-lua",
    keys = require('plugin-cfg.fzf').keys,
  },

  {
    "echasnovski/mini.files",
    -- lazy = false,
    keys = function(_, keys)
      return require('plugin-cfg.mini-files').keys(_, keys)
    end,
    opts = function(_, opts)
      return require('plugin-cfg.mini-files').opts(_, opts)
    end,
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim", },
      -- {"nvim-tree/nvim-web-devicons",},
      { "MunifTanjim/nui.nvim", },
      -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window
    },
    opts = function()
      return require('plugin-cfg.neo-tree').opts
    end,
  },

  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    dependencies = { "folke/snacks.nvim" },
    keys = function() return require('plugin-cfg.yazi').keys end,
    init = function() require('plugin-cfg.yazi').init() end,
    opts = function() return require('plugin-cfg.yazi').opts end,
  },
}
