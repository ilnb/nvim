return {
  {
    'saghen/blink.cmp',
    version = not vim.g.lazyvim_blink_main and '*',
    build = vim.g.lazyvim_blink_main and 'cargo build --release',
    opts_extend = {
      'sources.default',
    },
    dependencies = {
      -- {
      --   'archie-judd/blink-cmp-words',
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
          Text          = '󰉿 ', -- 
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
          ['<C-s>'] = { 'show' },
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
        ['<C-s>'] = { 'show', 'show_documentation', 'hide_documentation' },
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
          name = 'blink-cmp-words',
          module = 'blink-cmp-words.thesaurus',
          opts = {
            score_offset = 0,
            pointer_symbols = { '!', '&', '^' },
          },
        },

        dictionary = {
          name = 'blink-cmp-words',
          module = 'blink-cmp-words.dictionary',
          opts = {
            dictionary_search_threshold = 3,
            score_offset = 0,
            pointer_symbols = { '!', '&', '^' },
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
  },

  {
    'L3MON4D3/LuaSnip',
    -- filetype = { 'c', 'cpp' },
  },

  {
    'kevinhwang91/nvim-ufo',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = { 'kevinhwang91/promise-async' },

    keys = {
      {
        'zR',
        function()
          require 'ufo'.openAllFolds()
        end,
        desc = 'Open all folds',
      },

      {
        'zM',
        function()
          require 'ufo'.closeAllFolds()
        end,
        desc = 'Close all folds',
      },

      {
        'zp',
        function()
          local winid = require 'ufo'.peekFoldedLinesUnderCursor()
          if not winid then
            vim.lsp.buf.hover()
          end
        end,
        desc = 'Peek fold or LSP hover',
      },
    },

    opts = {
      preview = {
        win_config = {
          border = 'rounded',
          winhighlight = 'Normal:NormalFloat',
          winblend = 10,
        },
        mappings = {
          scrollU = '<C-u>',
          scrollD = '<C-d>',
        },
      },
      provider_selector = function(_, filetype, buftype)
        local function handleFallbackException(bufnr, err, providerName)
          if type(err) == 'string' and err:match 'UfoFallbackException' then
            return require 'ufo'.getFolds(bufnr, providerName)
          else
            return require 'promise'.reject(err)
          end
        end
        return (filetype == '' or buftype == 'nofile') and 'indent' -- only use indent until a file is opened
            or function(bufnr)
              return require 'ufo'
                  .getFolds(bufnr, 'lsp')
                  :catch(function(err)
                    return handleFallbackException(bufnr, err, 'treesitter')
                  end)
                  :catch(function(err)
                    return handleFallbackException(bufnr, err, 'indent')
                  end)
            end
      end,
    }
  },


  {
    'nvim-treesitter/nvim-treesitter',
    version = false, -- last release is way too old and doesn't work on Windows
    build = ':TSUpdate',
    event = { 'BufReadPre', 'BufNewFile' },
    lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
    --[[
    init = function(plugin)
      -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
      -- This is needed because a bunch of plugins no longer `require('nvim-treesitter')`, which
      -- no longer trigger the **nvim-treesitter** module to be loaded in time.
      -- Luckily, the only things that those plugins need are the custom queries, which we make available
      -- during startup.
      require 'lazy.core.loader'.add_to_rtp(plugin)
      require 'nvim-treesitter.query_predicates'
    end,
    --]]
    cmd = { 'TSUpdateSync', 'TSUpdate', 'TSInstall' },
    keys = {
      { '<c-space>', desc = 'Increment Selection' },
      { '<bs>',      desc = 'Decrement Selection', mode = 'x' },
    },
    opts_extend = { 'ensure_installed' },
    ---@type TSConfig
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
        'asm',
        'bash',
        'c',
        'cpp',
        'css',
        'diff',
        'html',
        'hyprlang',
        'javascript',
        'jsdoc',
        'json',
        'jsonc',
        'lua',
        'luadoc',
        'luap',
        'markdown',
        'markdown_inline',
        'python',
        'query',
        'regex',
        'toml',
        'typescript',
        'vim',
        'vimdoc',
        'xml',
        'yaml',
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-space>',
          node_incremental = '<C-space>',
          scope_incremental = false,
          node_decremental = '<bs>',
        },
      },
      textobjects = {
        move = {
          enable = true,
          goto_next_start = { [']f'] = '@function.outer', [']c'] = '@class.outer', [']a'] = '@parameter.inner' },
          goto_next_end = { [']F'] = '@function.outer', [']C'] = '@class.outer', [']A'] = '@parameter.inner' },
          goto_previous_start = { ['[f'] = '@function.outer', ['[c'] = '@class.outer', ['[a'] = '@parameter.inner' },
          goto_previous_end = { ['[F'] = '@function.outer', ['[C'] = '@class.outer', ['[A'] = '@parameter.inner' },
        },
        swap = {
          enable = true,
          swap_next = { ['<A-l>'] = '@parameter.inner' },
          swap_previous = { ['<A-h>'] = '@parameter.inner' }
        }
      },
    },
    ---@param opts TSConfig
    config = function(_, opts)
      require 'nvim-treesitter.configs'.setup(opts)
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    event = { 'BufReadPre', 'BufNewFile' },
    enabled = true,
    config = function()
      local move = require 'nvim-treesitter.textobjects.move' ---@type table<string,fun(...)>
      local configs = require 'nvim-treesitter.configs'
      for name, fn in pairs(move) do
        if name:find 'goto' == 1 then
          move[name] = function(q, ...)
            if vim.wo.diff then
              local config = configs.get_module 'textobjects.move'[name] ---@type table<string,string>
              for key, query in pairs(config or {}) do
                if q == query and key:find '[%]%[][cC]' then
                  vim.cmd('normal! ' .. key)
                  return
                end
              end
            end
            return fn(q, ...)
          end
        end
      end
    end,
  },

  {
    'folke/todo-comments.nvim',
    cmd = { 'TodoTelescope' },
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {},
    -- stylua: ignore
    keys = {
      { ']t',         function() require 'todo-comments'.jump_next() end, desc = 'Next Todo Comment' },
      { '[t',         function() require 'todo-comments'.jump_prev() end, desc = 'Previous Todo Comment' },
      { '<leader>st', '<cmd>TodoTelescope<cr>',                           desc = 'Todo' },
      { '<leader>sT', '<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>',   desc = 'Todo/Fix/Fixme' },
    },
  },

  {
    'echasnovski/mini.indentscope',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = function()
      return {
        char = '┊',
      }
    end,
  }
}
