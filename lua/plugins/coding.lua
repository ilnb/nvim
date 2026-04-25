return {
  {
    'saghen/blink.cmp',
    build = function()
      require 'blink.cmp'.build():map(function() ---@diagnostic disable-line
        vim.api.nvim_create_autocmd('UIEnter', {
          once = true,
          callback = function()
            vim.notify('blink.cmp: Build successful', vim.log.levels.INFO)
          end
        })
      end)
    end,
    dependencies = {
      {
        'saghen/blink.lib'
      },
      -- {
      --   'archie-judd/blink-cmp-words',
      --   event = 'InsertEnter',
      -- }
    },

    event = { 'BufNewFile', 'BufReadPost', 'CmdLineEnter' },

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      fuzzy = {
        implementation = 'prefer_rust_with_warning',
      },
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
            treesitter = { 'markdown' },
            padding = 1,
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
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      {
        'nvim-treesitter/nvim-treesitter-textobjects',
        event = { 'BufReadPre', 'BufNewFile' },
      }
    },
    opts = {
      ignore = { 'csv' },
      ensure = {
        'asm', 'bash', 'c', 'cpp', 'css', 'diff',
        'html', 'hyprlang', 'javascript', 'jsdoc',
        'json', 'lua', 'luadoc', 'luap',
        'markdown', 'markdown_inline', 'python',
        'query', 'regex', 'toml', 'typescript',
        'typst', 'vim', 'vimdoc', 'xml', 'yaml',
        'zig', 'desktop',
      },
    },
    config = function(_, opts)
      local ok, ts = pcall(require, 'nvim-treesitter')
      if not ok then return end
      ts.setup(opts)

      local langs = vim.tbl_filter(function(l)
        return not vim.tbl_contains(opts.ignore or {}, l)
      end, opts.ensure)

      local have = ts.get_installed()
      local available = ts.get_available()

      local function attach(buf)
        local ft = vim.bo[buf].filetype
        if ft == '' or not vim.tbl_contains(langs, ft) then return end

        pcall(vim.treesitter.start, buf)
        if vim.bo[buf].indentexpr == '' then
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end

      local to_install = vim.tbl_filter(function(l)
        return not vim.tbl_contains(have, l) and vim.tbl_contains(available, l)
      end, langs)

      if #to_install > 0 then
        ts.install(to_install):await(function()
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            attach(buf)
          end
        end)
      end

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('treesitter_attach', { clear = true }),
        pattern = langs,
        callback = function(ev)
          attach(ev.buf)
        end,
      })

      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        attach(buf)
      end

      local map = vim.keymap.set

      local move = require 'nvim-treesitter-textobjects.move'
      local move_tbl = { f = '@function.outer', c = '@class.outer', a = '@parameter.inner' }
      local strs = { f = 'function', c = 'class', a = 'parameter' }
      for key, capture in pairs(move_tbl) do
        local str = strs[key]
        map('n', ']' .. key, function() move.goto_next_start(capture, 'textobjects') end,
          { desc = 'Next ' .. str .. ' start' })
        map('n', ']' .. key:upper(), function() move.goto_next_end(capture, 'textobjects') end,
          { desc = 'Next ' .. str .. ' end' })
        map('n', '[' .. key, function() move.goto_previous_start(capture, 'textobjects') end,
          { desc = 'Prev ' .. str .. ' start' })
        map('n', '[' .. key:upper(), function() move.goto_previous_end(capture, 'textobjects') end,
          { desc = 'Prev ' .. str .. ' end' })
      end

      local swap = require 'nvim-treesitter-textobjects.swap'
      map('n', '<a-l>', function() swap.swap_next '@parameter.inner' end, { desc = 'Swap inner parameter' })
      map('n', '<a-h>', function() swap.swap_previous '@parameter.inner' end, { desc = 'Swap outer parameter' })
    end,
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
    'nvim-mini/mini.indentscope',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function(_, opts)
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
