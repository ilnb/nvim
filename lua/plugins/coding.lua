return {
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
    },
    event = "VeryLazy",
    opts = function(_, opts)
      return require('plugin-cfg.blink').opts(_, opts)
    end,
    config = function(_, opts)
      require('plugin-cfg.blink').config(_, opts)
    end,
  },

  {
    "L3MON4D3/LuaSnip",
    filetype = { 'c', 'cpp' },
  },

  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        keys = function() return require('plugin-cfg.dap_ui').keys end,
        config = function(_, opts)
          require('plugin-cfg.dap_ui').config(_, opts)
        end,
      },
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },
    },
    keys = function(_, keys) return require('plugin-cfg.dap').keys(_, keys) end,
    config = function() require('plugin-cfg.dap').config() end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts) require('plugin-cfg.lspconfig').opts(_, opts) end
  },

  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      -- "nvim-treesitter/playground",
      "nvim-treesitter/nvim-treesitter-textobjects",
      "echasnovski/mini.ai",
    },
    opts = function(_, opts)
      return require('plugin-cfg.treesitter').opts(_, opts)
    end
  },
}
