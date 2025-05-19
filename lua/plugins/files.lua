return {
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    config = require('plugin-cfg.bufferline').config,
    keys = require('plugin-cfg.bufferline').keys,
    opts = require('plugin-cfg.bufferline').opts
  },

  {
    "ibhagwan/fzf-lua",
    keys = require('plugin-cfg.fzf').keys
  },

  {
    "echasnovski/mini.files",
    config = require('plugin-cfg.mini_files').config,
    keys = require('plugin-cfg.mini_files').keys,
    opts = require('plugin-cfg.mini_files').opts
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    opts = require('plugin-cfg.neo_tree').opts
  },

  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    dependencies = { "folke/snacks.nvim" },
    init = require('plugin-cfg.yazi').init,
    keys = require('plugin-cfg.yazi').keys,
    opts = require('plugin-cfg.yazi').opts
  },
}
