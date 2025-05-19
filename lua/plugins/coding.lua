return {
  {
    "saghen/blink.cmp",
    version = not vim.g.lazyvim_blink_main and "*",
    build = vim.g.lazyvim_blink_main and "cargo build --release",
    opts_extend = require('plugin-cfg.blink').opts_extend,
    dependencies = {
      {
        "saghen/blink.compat",
        optional = true, -- make optional so it's only enabled if any extras need it
        opts = {},
        version = not vim.g.lazyvim_blink_main and "*",
      },
    },
    event = "InsertEnter",
    config = require('plugin-cfg.blink').config,
    opts = require('plugin-cfg.blink').opts
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
    keys = require('plugin-cfg.dap_ui').keys,
    opts = require('plugin-cfg.dap_ui').opts,
    config = require('plugin-cfg.dap_ui').config
      },
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },
    },
    config = require('plugin-cfg.dap').config,
    keys = require('plugin-cfg.dap').keys
  }
}
