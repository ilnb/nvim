local M = {}

M.opts_extend = {
  "sources.compat",
  "sources.default",
}

---@module 'blink.cmp'
---@type blink.cmp.Config
M.opts = {
  appearance = {
    -- sets the fallback highlight groups to nvim-cmp's highlight groups
    -- useful for when your theme doesn't support blink.cmp
    -- will be removed in a future release, assuming themes add support
    use_nvim_cmp_as_default = false,
    -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
    -- adjusts spacing to ensure icons are aligned
    nerd_font_variant = "normal",
  },
  completion = {
    accept = {
      auto_brackets = {
        enabled = true,
      },
    },
    menu = {
      border = "rounded",
      auto_show = true,
      winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
    },
    documentation = {
      window = {
        border = "rounded",
        winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
      },
      auto_show = true,
    },
    ghost_text = {
      enabled = vim.g.ai_cmp,
    },
  },
  -- experimental signature help support
  -- signature = { enabled = true },
  snippets = {
    preset = "luasnip",
  },
  sources = {
    -- adding any nvim-cmp sources here will enable them
    -- with blink.compat
    compat = {},
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
  keymap = {
    preset = "enter",
    ["<C-y>"] = { "select_and_accept" },
  },
}

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

  -- setup compat sources
  local enabled = opts.sources.default
  for _, source in ipairs(opts.sources.compat or {}) do
    opts.sources.providers[source] = vim.tbl_deep_extend(
      "force",
      { name = source, module = "blink.compat.source" },
      opts.sources.providers[source] or {}
    )
    if type(enabled) == "table" and not vim.tbl_contains(enabled, source) then
      table.insert(enabled, source)
    end
  end

  -- add ai_accept to <Tab> key
  if not opts.keymap["<Tab>"] then
    if opts.keymap.preset == "super-tab" then -- super-tab
      opts.keymap["<Tab>"] = {
        require("blink.cmp.keymap.presets")["super-tab"]["<Tab>"][1],
        LazyVim.cmp.map({ "snippet_forward", "ai_accept" }),
        "fallback",
      }
    else -- other presets
      opts.keymap["<Tab>"] = {
        LazyVim.cmp.map({ "snippet_forward", "ai_accept" }),
        "fallback",
      }
    end
  end

  -- Unset custom prop to pass blink.cmp validation
  opts.sources.compat = nil

  -- check if we need to override symbol kinds
  for _, provider in pairs(opts.sources.providers or {}) do
    ---@cast provider blink.cmp.SourceProviderConfig|{kind?:string}
    if provider.kind then
      local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
      local kind_idx = #CompletionItemKind + 1

      CompletionItemKind[kind_idx] = provider.kind
      ---@diagnostic disable-next-line: no-unknown
      CompletionItemKind[provider.kind] = kind_idx

      ---@type fun(ctx: blink.cmp.Context, items: blink.cmp.CompletionItem[]): blink.cmp.CompletionItem[]
      local transform_items = provider.transform_items
      ---@param ctx blink.cmp.Context
      ---@param items blink.cmp.CompletionItem[]
      provider.transform_items = function(ctx, items)
        items = transform_items and transform_items(ctx, items) or items
        for _, item in ipairs(items) do
          item.kind = kind_idx or item.kind
        end
        return items
      end

      -- Unset custom prop to pass blink.cmp validation
      provider.kind = nil
    end
  end

  require("blink.cmp").setup(opts)
end

return M
