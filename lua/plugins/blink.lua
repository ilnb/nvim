return {
  'saghen/blink.cmp',
  version = not vim.g.lazyvim_blink_main and '*',
  build = vim.g.lazyvim_blink_main and 'cargo build --release',
  opts_extend = {
    'sources.default',
  },
  dependencies = {
    -- {
    --   "archie-judd/blink-cmp-words",
    --   event = 'InsertEnter',
    -- }
  },

  event = { 'BufNewFile', 'BufReadPost', 'CmdLineEnter' },

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    appearance = {
      kind_icons = {
        Array         = ' ',
        Boolean       = '󰨙 ',
        Class         = ' ',
        Color         = ' ',
        Control       = ' ',
        Collapsed     = ' ',
        Constant      = '󰏿 ',
        Constructor   = ' ',
        Enum          = ' ',
        EnumMember    = ' ',
        Event         = ' ',
        Field         = ' ',
        File          = ' ',
        Folder        = ' ',
        Function      = '󰊕 ',
        Interface     = ' ',
        Key           = ' ',
        Keyword       = ' ',
        Method        = '󰊕 ',
        Module        = ' ',
        Namespace     = '󰦮 ',
        Null          = ' ',
        Number        = '󰎠 ',
        Object        = ' ',
        Operator      = ' ',
        Package       = ' ',
        Property      = ' ',
        Reference     = ' ',
        Snippet       = '󱄽 ',
        String        = ' ',
        Struct        = '󰆼 ',
        Supermaven    = ' ',
        Text          = ' ',
        TypeParameter = ' ',
        Unit          = ' ',
        Value         = ' ',
        Variable      = '󰀫 ',
      }
    },
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
    },
    sources = {
      default = {
        'lsp',
        -- 'lazydev',
        'path',
        'snippets',
        'buffer',
        -- 'dictionary'
      },
      providers = {
        -- lazydev = {
        --   name = 'LazyDev',
        --   module = 'lazydev.integrations.blink',
        --   score_offset = 80, -- show at a higher priority than lsp
        -- },

        path = {
          opts = { show_hidden_files_by_default = true },
        },

        -- snippets = {
        --   name = 'LuaSnip',
        --   score_offset = 100,
        -- },

        --[[
        thesaurus = {
          name = "blink-cmp-words",
          module = "blink-cmp-words.thesaurus",
          opts = {
            score_offset = 0,
            pointer_symbols = { "!", "&", "^" },
          },
        },

        dictionary = {
          name = "blink-cmp-words",
          module = "blink-cmp-words.dictionary",
          opts = {
            dictionary_search_threshold = 3,
            score_offset = 0,
            pointer_symbols = { "!", "&", "^" },
          },
        },
        --]]
      },
      --[[
      per_filetype = {
        text = { 'dictionary' },
        markdown = { 'thesaurus' },
      }
      --]]
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

    opts.sources.compat = nil
    require 'blink.cmp'.setup(opts)
  end
}
