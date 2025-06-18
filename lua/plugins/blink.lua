return {
  "saghen/blink.cmp",
  version = not vim.g.lazyvim_blink_main and "*",
  build = vim.g.lazyvim_blink_main and "cargo build --release",
  opts_extend = {
    "sources.compat",
    "sources.default",
  },
  dependencies = {
    {
      "saghen/blink.compat",
      optional = true, -- make optional so it's only enabled if any extras need it
      opts = {},
      version = not vim.g.lazyvim_blink_main and "*",
    },
  },
  event = function()
    return { "BufNewFile", "BufReadPost", "CmdLineEnter" }
  end,
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    cmdline = { enabled = true },
    completion = {
      menu = {
        border = "rounded",
        auto_show = true,
        winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
        scrollbar = false,
      },
      documentation = {
        auto_show = true, -- doc window for completions
        auto_show_delay_ms = 0,
        treesitter_highlighting = true,
        window = {
          border = "rounded",
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
          scrollbar = false,
        }
      },
    },
    snippets = { preset = "luasnip" },
    sources = {
      default = { "lsp", "lazydev", "path", "snippets", "buffer" },
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 80, -- show at a higher priority than lsp
        },
        path = {
          opts = { show_hidden_files_by_default = true },
        },
        -- snippets = {
        --   name = "LuaSnip",
        --   score_offset = 100,
        -- },
      },
    },
  },
  ---@param opts blink.cmp.Config | { sources: { compat: string[] } }
  config = function(_, opts)
    -- snippets
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "c", "cpp" },
      callback = function(args)
        local luasnip = require("luasnip")
        if args.match == "c" then
          luasnip.add_snippets("c", require("snippets.c"))
        elseif args.match == "cpp" then
          luasnip.add_snippets("cpp", require("snippets.cpp"))
        end
      end,
    })
    -- use lazyvim's config
    require('lazyvim.plugins.extras.coding.blink')[2].config(_, opts)
  end
}
