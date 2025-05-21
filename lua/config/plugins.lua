local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

local plugins = {

  -- colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = require('config.utils').wm_colorscheme(),
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

  -- ui
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

  -- navigation
  {
    "akinsho/bufferline.nvim",
    -- event = "VeryLazy",
    keys = function() return require('plugin-cfg.bufferline').keys end,
    opts = function() return require('plugin-cfg.bufferline').opts end,
    config = function(_, opts)
      require('plugin-cfg.bufferline').config(_, opts)
    end,
  },

  {
    "ibhagwan/fzf-lua",
    keys = require('plugin-cfg.fzf').keys,
  },

  {
    "echasnovski/mini.files",
    -- lazy = false,
    keys = require('plugin-cfg.mini_files').keys,
    opts = require('plugin-cfg.mini_files').opts,
    config = function(_, opts)
      require('plugin-cfg.mini_files').config(_, opts)
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
    -- opts = require('plugin-cfg.neo_tree').opts
  },

  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    dependencies = { "folke/snacks.nvim" },
    -- keys = require('plugin-cfg.yazi').keys,
    init = function() require('plugin-cfg.yazi').init() end,
    opts = function() return require('plugin-cfg.yazi').opts end,
  },

  -- coding
  {
    "saghen/blink.cmp",
    version = not vim.g.lazyvim_blink_main and "*",
    build = vim.g.lazyvim_blink_main and "cargo build --release",
    opts_extend = function() return require('plugin-cfg.blink').opts_extend end,
    dependencies = {
      {
        "saghen/blink.compat",
        optional = true, -- make optional so it's only enabled if any extras need it
        opts = {},
        version = not vim.g.lazyvim_blink_main and "*",
      },
      {
        "L3MON4D3/LuaSnip",
        filetype = { 'c', 'cpp' },
      },
    },
    event = "InsertEnter",
    opts = function() return require('plugin-cfg.blink').opts end,
    config = function(_, opts)
      require('plugin-cfg.blink').config(_, opts)
    end,
  },

  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        keys = function() return require('plugin-cfg.dap_ui').keys end,
        opts = function() return require('plugin-cfg.dap_ui').opts end,
        config = function(_, opts)
          require('plugin-cfg.dap_ui').config(_, opts)
        end
      },
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },
    },
    keys = function() return require('plugin-cfg.dap').keys end,
    config = function() require('plugin-cfg.dap').config() end
  },

  -- disabled
  {
    "MagicDuck/grug-far.nvim",
    enabled = false
  },

  {
    "folke/ts-comments.nvim",
    enabled = false
  },

  {
    "stevearc/conform.nvim",
    enabled = false
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false
  },

  {
    "mfussenegger/nvim-dap",
    enabled = false
  },

  {
    "folke/persistence.nvim",
    enabled = false
  },

  {
    "rafamadriz/friendly-snippets",
    enabled = false
  },

  {
    "echasnovski/mini.files",
    -- enabled = false
  },

  {
    "nvim/catppuccin",
    enabled = false
  },

  {
    "folke/tokyonight.nvim",
    enabled = false
  },

  {
    "mikalvipas/yazi.nvim",
    enabled = false,
  },

  {
    "echasnovski/mini.ai",
    enabled = false,
  },
}

require("lazy").setup({
  ui = { border = "rounded" },
  spec = {
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    plugins
  },
  defaults = {
    lazy = true,
    version = false, -- always use the latest git commit
  },
  install = { colorscheme = { "kanagawa" } },
  checker = {
    enabled = true,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
