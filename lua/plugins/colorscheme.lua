return {
  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = require('config.utils').wm_colorscheme()
      colorscheme = "kanagawa",
    },
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = function() return require('plugin-cfg.catppuccin').options end,
    spec = function() return require('plugin-cfg.catppuccin').spec end,
  },

  {
    "rebelot/kanagawa.nvim",
    config = function() require('plugin-cfg.kanagawa').config() end
  },

  {
    "marko-cerovac/material.nvim",
    config = function() require('plugin-cfg.material').config() end
    -- init = function() require('plugin-cfg.material').init() end,
    -- opts = function() return require('plugin-cfg.material').opts end
  },

  {
    "folke/tokyonight.nvim",
    opts = { style = "night" },
  },
}
