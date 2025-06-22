return {
  'saghen/blink.cmp',
  version = not vim.g.lazyvim_blink_main and '*',
  build = vim.g.lazyvim_blink_main and 'cargo build --release',
  opts_extend = {
    'sources.default',
  },

  event = function()
    return { 'BufNewFile', 'BufReadPost', 'CmdLineEnter' }
  end,

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    cmdline = {
      enabled = true,
      completion = {
        menu = { auto_show = true },
        list = { selection = { preselect = false, auto_insert = true } },
      },
      keymap = {
        ['<CR>'] = { 'accept', 'fallback' },
        ['<Tab>'] = { 'select_next', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'fallback' },
        ['<C-e>'] = { 'cancel', 'fallback' },
        ['<C-y>'] = { 'select_and_accept' },
      }
    },

    completion = {
      accept = {
        auto_brackets = {
          enabled = true,
        },
      },
      list = { selection = { preselect = true, auto_insert = false } },
      menu = {
        auto_show = true,
        border = 'rounded',
        draw = {
          treesitter = { 'lsp' }
        },
        winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpMenuSelection,Search:None',
        scrollbar = false,
      },

      documentation = {
        auto_show = true, -- doc window for completions
        auto_show_delay_ms = 0,
        treesitter_highlighting = true,
        window = {
          border = 'rounded',
          winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
          scrollbar = false,
        }
      },
      ghost_text = {
        enabled = true,
        -- enabled = vim.g.ai_cmp,
      }
    },

    keymap = {
      ['<CR>'] = { 'accept', 'fallback' },
      -- ['<Esc>'] = { 'hide', 'fallback' },
      ['<Up>'] = { 'select_prev', 'fallback' },
      ['<Down>'] = { 'select_next', 'fallback' },
      ['<C-e>'] = { 'cancel', 'show', 'fallback' },
      ['<C-p>'] = { 'select_prev', 'fallback' },
      ['<C-n>'] = { 'select_next', 'fallback' },
      ['<C-y>'] = { 'select_and_accept' },
      ['<C-k>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
      ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
      ['<S-up>'] = { 'scroll_documentation_up', 'fallback' },
      ['<S-down>'] = { 'scroll_documentation_down', 'fallback' },
    },

    snippets = {
      preset = 'luasnip',
      expand = function(snippet)
        return LazyVim.cmp.expand(snippet)
      end,
    },
    sources = {
      default = { 'lsp', 'lazydev', 'path', 'snippets', 'buffer' },
      providers = {
        lazydev = {
          name = 'LazyDev',
          module = 'lazydev.integrations.blink',
          score_offset = 80, -- show at a higher priority than lsp
        },

        path = {
          opts = { show_hidden_files_by_default = true },
        },

        -- snippets = {
        --   name = 'LuaSnip',
        --   score_offset = 100,
        -- },
      },
    },
  },

  ---@param opts blink.cmp.Config | { sources: { compat: string[] } }
  config = function(_, opts)
    -- snippets
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'c', 'cpp' },
      callback = function(args)
        local luasnip = require 'luasnip'
        if args.match == 'c' then
          luasnip.add_snippets('c', require 'snippets.c')
        elseif args.match == 'cpp' then
          luasnip.add_snippets('cpp', require 'snippets.cpp')
        end
      end,
    })

    -- use lazyvim's config for setting up compat sources
    -- require 'lazyvim.plugins.extras.coding.blink'[2].config(_, opts)
    -- otherwise
    opts.appearance = opts.appearance or {}
    opts.appearance.kind_icons = vim.tbl_extend('force', opts.appearance.kind_icons or {}, LazyVim.config.icons.kinds)
    opts.sources.compat = nil
    require 'blink.cmp'.setup(opts)
  end
}
