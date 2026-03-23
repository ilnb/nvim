return {
  {
    'saghen/blink.cmp',
    build = 'cargo build --release',
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
        kind_icons = NeoVim.icons.kind,
      },
      cmdline = {
        enabled = true,
        completion = {
          menu = { auto_show = true },
          list = { selection = { preselect = false, auto_insert = true } },
        },
        keymap = {
          ['<cr>'] = { 'accept', 'fallback' },
          ['<tab>'] = { 'select_next', 'fallback' },
          ['<s-tab>'] = { 'select_prev', 'fallback' },
          ['<c-e>'] = { 'cancel', 'fallback' }, -- also shows
          ['<c-y>'] = { 'select_and_accept' },
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
            treesitter = { 'lsp' },
            padding = { 0, 1 },
            components = {
              source_name = {
                width = { fill = true },
                text = function(ctx)
                  local str = ctx.source_name:lower()
                  if str == 'buffer' then
                    str = 'buf'
                  elseif str == 'cmdline' then
                    return ''
                  elseif str == 'snippets' then
                    str = 'snip'
                  end
                  return '[' .. str .. ']'
                end
              },
              label_description = {
                text = function(ctx)
                  local mode = vim.api.nvim_get_mode().mode
                  return mode ~= 'c' and '' or ctx.label_description -- only show it in cmdline
                end
              },
            },
            columns = {
              { 'kind_icon',   'label' },
              { 'source_name', 'label_description', gap = 1 },
            },
          },
          winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpMenuSelection,Search:None',
          scrollbar = false,
        },

        documentation = {
          auto_show = true,
          auto_show_delay_ms = 0,
          treesitter_highlighting = true,
          window = {
            border = 'rounded',
            winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
            scrollbar = false,
          }
        },
        ghost_text = {
          enabled = false,
        }
      },

      keymap = {
        ['<cr>'] = { 'accept', 'fallback' },
        ['<up>'] = { 'select_prev', 'fallback' },
        ['<down>'] = { 'select_next', 'fallback' },
        ['<c-e>'] = { 'cancel', 'show', 'fallback' },
        ['<c-p>'] = { 'select_prev', 'fallback' },
        ['<c-n>'] = { 'select_next', 'fallback' },
        ['<c-y>'] = { 'cancel', 'show' },
        ['<tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
        ['<s-tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
        ['<s-up>'] = { 'scroll_documentation_up', 'fallback' },
        ['<s-down>'] = { 'scroll_documentation_down', 'fallback' },
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
          path = {
            opts = { show_hidden_files_by_default = true },
          },

          -- thesaurus = {
          --   name = 'blink-cmp-words',
          --   module = 'blink-cmp-words.thesaurus',
          --   opts = {
          --     score_offset = 0,
          --     definition_pointers = { '!', '&', '^' },
          --   },
          -- },

          -- dictionary = {
          --   name = 'blink-cmp-words',
          --   module = 'blink-cmp-words.dictionary',
          --   opts = {
          --     dictionary_search_threshold = 3,
          --     score_offset = 0,
          --     definition_pointers = { '!', '&', '^' },
          --   },
          -- },
        },
        -- per_filetype = {
        --   text = { 'dictionary' },
        --   markdown = { 'thesaurus' },
        -- }
      },
    },

    ---@param opts blink.cmp.Config | { sources: { compat: string[] } }
    config = function(_, opts)
      -- snippets
      vim.api.nvim_create_autocmd('FileType', {
        pattern = NeoVim.snippets.langs,
        callback = function(args)
          local ls = require 'luasnip'
          for _, lang in ipairs(NeoVim.snippets.langs) do
            if args.match == lang and not NeoVim.snippets.lang_done[lang] then
              ls.add_snippets(lang, require('snippets.' .. lang))
              NeoVim.snippets.lang_done[lang] = true
              break
            end
          end
        end,
      })

      opts.sources.compat = nil
      require 'blink.cmp'.setup(opts)
    end
  },

  {
    'L3MON4D3/LuaSnip',
    name = 'luasnip',
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
    build = ':TSUpdate',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
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
      ignore_install = { 'csv' },
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
        'asm', 'bash', 'c', 'cpp', 'css', 'diff',
        'html', 'hyprlang', 'javascript', 'jsdoc',
        'json', 'jsonc', 'lua', 'luadoc', 'luap',
        'markdown', 'markdown_inline', 'python',
        'query', 'regex', 'toml', 'typescript',
        'typst', 'vim', 'vimdoc', 'xml', 'yaml',
        'zig', 'desktop',
      },
    },
    ---@param opts TSConfig
    config = function(_, opts)
      local ok, tsconfig = pcall(require, 'nvim-treesitter.configs')
      if not ok then return end
      tsconfig.setup(opts)

      local map = vim.keymap.set

      -- move keys
      local move = require 'nvim-treesitter-textobjects.move'
      local move_tbl = {
        f = '@function.outer',
        c = '@class.outer',
        a = '@parameter.inner'
      }
      for key, capture in pairs(move_tbl) do
        map('n', ']' .. key, function() move.goto_next_start(capture, 'textobjects') end)
        map('n', ']' .. key:upper(), function() move.goto_next_end(capture, 'textobjects') end)
        map('n', '[' .. key, function() move.goto_previous_start(capture, 'textobjects') end)
        map('n', '[' .. key:upper(), function() move.goto_previous_end(capture, 'textobjects') end)
      end

      -- swap keys
      local swap = require 'nvim-treesitter-textobjects.swap'
      map('n', '<A-l>', function() swap.swap_next '@parameter.inner' end)
      map('n', '<A-h>', function() swap.swap_previous '@parameter.inner' end)
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    event = { 'BufReadPre', 'BufNewFile' },
    enabled = true,
  },

  {
    'folke/todo-comments.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {},
    keys = {
      { ']t',         function() require 'todo-comments'.jump_next() end,                               desc = 'Next Todo Comment' },
      { '[t',         function() require 'todo-comments'.jump_prev() end,                               desc = 'Previous Todo Comment' },
      { '<leader>st', function() require 'todo-comments.fzf'.todo() end,                                desc = 'Todo' },
      { '<leader>sT', function() require 'todo-comments.fzf'.todo { keywords = { 'TODO', 'FIX' } } end, desc = 'Todo/Fix' },
    },
  },

  {
    'echasnovski/mini.indentscope',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require 'mini.indentscope'.setup {
        char = '┊', -- ╎
        draw = {
          delay = 0,
          animation = require 'mini.indentscope'.gen_animation.quadratic { easing = 'out', duration = 20, unit = 'step' },
        },
        options = {
          try_as_border = true,
        },
      }
    end
  },

  {
    'ray-x/lsp_signature.nvim',
  },

}
