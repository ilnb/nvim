local M = {}

M.opts_extend = {
  "sources.compat",
  "sources.default",
}

---@module 'blink.cmp'
---@param opts blink.cmp.Config
M.opts = function(_, opts)
  local cmp = opts.completion
  cmp.menu = {
    border = "rounded",
    auto_show = true,
    winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
    scrollbar = false
  }
  cmp.documentation = {
    auto_show = true, -- doc window for completions
    auto_show_delay_ms = 0,
    treesitter_highlighting = true,
    window = {
      border = "rounded",
      winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
      scrollbar = false,
    }
  }
  opts.snippets = { preset = "luasnip" }
  local src = opts.sources
  src.default = { "lsp", "lazydev", "path", "snippets", "buffer" }
  src.providers = {
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
  }
  opts.cmdline = {
    enabled = true
  }
  return opts
end

---@param opts blink.cmp.Config | { sources: { compat: string[] } }
M.config = function(_, opts)
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

return M
