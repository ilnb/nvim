return {
  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = require('config.utils').wm_colorscheme()
      colorscheme = "kanagawa",
    },
  },

  {
    "nvim/catppuccin",
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
