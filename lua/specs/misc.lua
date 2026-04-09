return {
  {
    'nvim-mini/mini.surround',
    modname = 'mini.surround',
    event = { 'BufNewFile', 'BufReadPost' },
    keys = {
      { 'gsa', '', desc = 'Add Surrounding',       mode = { 'n', 'v' } },
      { 'gsd', '', desc = 'Delete Surrounding' },
      { 'gsf', '', desc = 'Find Right Surrounding' },
      { 'gsF', '', desc = 'Find Left Surrounding' },
      { 'gsh', '', desc = 'Highlight Surrounding' },
      { 'gsr', '', desc = 'Replace Surrounding' },
    },
    opts = {
      mappings = {
        add = 'gsa',
        delete = 'gsd',
        find = 'gsf',
        find_left = 'gsF',
        highlight = 'gsh',
        replace = 'gsr',
      },
      n_lines = 40,
    },
    config = function(opts)
      require 'mini.surround'.setup(opts)
      vim.keymap.set('n', 'gsn', '<cmd>lua MiniSurround.update_n_lines()<cr>')
    end
  },

  {
    'nvim-mini/mini.pairs',
    event = { 'InsertEnter', 'CmdLineEnter' },
    modname = 'mini.pairs',
    opts = {
      modes = { insert = true, command = true, terminal = false },
      -- skip autopair when next character is one of these
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      -- skip autopair when the cursor is inside these treesitter nodes
      skip_ts = { 'string' },
      -- skip autopair when next character is closing pair
      -- and there are more closing pairs than opening pairs
      skip_unbalanced = true,
      -- better deal with markdown code blocks
      markdown = true,
    },
  },

  {
    'folke/flash.nvim',
    modname = 'flash',
    event = 'VeryLazy',
    ---@type Flash.Config
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      -- modes = {
      --   char = {
      --     jump_labels = true,
      --   },
      -- },
    },
    keys = {
      { 's',     mode = { 'n', 'x', 'o' }, function() Pack.proxy 'flash'.jump() end,              desc = 'Flash' },
      { 'S',     mode = { 'n', 'o', 'x' }, function() Pack.proxy 'flash'.treesitter() end,        desc = 'Flash Treesitter' },
      { 'r',     mode = 'o',               function() Pack.proxy 'flash'.remote() end,            desc = 'Remote Flash' },
      { 'R',     mode = { 'o', 'x' },      function() Pack.proxy 'flash'.treesitter_search() end, desc = 'Treesitter Search' },
      { '<c-s>', mode = { 'c' },           function() Pack.proxy 'flash'.toggle() end,            desc = 'Toggle Flash Search' },
      {
        '<c-space>',
        mode = { 'n', 'o', 'x' },
        function()
          Pack.proxy 'flash'.treesitter {
            actions = {
              ['<c-space>'] = 'next',
              ['<bs>'] = 'prev'
            }
          }
        end,
        desc = 'Incremental Selection'
      },
    },
  },

  {
    'folke/which-key.nvim',
    modname = 'which-key',
    event = 'VeryLazy',
    opts = {
      preset = 'helix',
      spec = {
        { '<BS>',      desc = 'Decrement Selection', mode = 'x' },
        { '<c-space>', desc = 'Increment Selection', mode = { 'x', 'n' } },
        {
          mode = { 'n', 'v' },
          { '<leader>t', group = 'tabs' },
          { '<leader>l', group = 'lsp' },
          { '<leader>f', group = 'file/find' },
          { '<leader>g', group = 'git' },
          { '<leader>gh', group = 'hunks' },
          { '<leader>q', group = 'quit' },
          { '<leader>s', group = 'search' },
          { '<leader>u', group = 'ui', icon = { icon = '󰙵 ', color = 'cyan' } },
          { '[', group = 'prev' },
          { ']', group = 'next' },
          { 'g', group = 'goto' },
          { 'gs', group = 'surround' },
          { 'z', group = 'fold' },
          {
            '<leader>b',
            group = 'buffer',
            expand = function()
              return Pack.proxy 'which-key.extras'.expand.buf()
            end,
          },
          {
            '<leader>w',
            group = 'windows',
            proxy = '<c-w>',
            expand = function()
              return Pack.proxy 'which-key.extras'.expand.win()
            end,
          },
          -- better descriptions
          { 'gx', desc = 'Open with system app' },
        },
      },
    },
    keys = {
      {
        '<leader>?',
        function()
          Pack.proxy 'which-key'.show { global = true }
        end,
        desc = 'Buffer Keymaps (which-key)',
      },
      {
        '<c-w><space>',
        function()
          Pack.proxy 'which-key'.show { keys = '<c-w>', loop = true }
        end,
        desc = 'Window Hydra Mode',
      },
      {
        '<space>b<space>',
        function()
          Pack.proxy 'which-key'.show { keys = '<space>b', loop = true }
        end,
        desc = 'Buffer Hydra Mode',
      }
    },
  },

  {
    'folke/noice.nvim',
    modname = 'noice',
    event = 'VeryLazy',
    deps = {
      { 'MunifTanjim/nui.nvim' },
    },
    keys = {
      { '<leader>sn',  '',                                          desc = '+noice' },
      -- { '<leader>snl', function() Pack.proxy 'noice'.cmd 'last' end,    desc = 'Noice Last Message' },
      -- { '<leader>snh', function() Pack.proxy 'noice'.cmd 'history' end, desc = 'Noice History' },
      { '<leader>sna', function() Pack.proxy 'noice'.cmd 'all' end, desc = 'Noice All' },
      -- { '<leader>snd', function() Pack.proxy 'noice'.cmd 'dismiss' end, desc = 'Dismiss All' },
      -- { '<leader>snt', function() Pack.proxy 'noice'.cmd 'pick' end,    desc = 'Noice Picker (Telescope/FzfLua)' },
      {
        '<c-f>',
        function() if not Pack.proxy 'noice.lsp'.scroll(4) then return '<c-f>' end end,
        silent = true,
        expr = true,
        desc = 'Scroll Forward',
        mode = { 'i', 'n', 's' }
      },
      {
        '<c-b>',
        function() if not Pack.proxy 'noice.lsp'.scroll(-4) then return '<c-b>' end end,
        silent = true,
        expr = true,
        desc = 'Scroll Backward',
        mode = { 'i', 'n', 's' }
      },
    },

    ---@diagnostic disable: missing-fields
    ---@type NoiceConfig
    opts = {
      views = {
        hover = {
          scrollbar = true,
        },
      },
      cmdline = {
        view = 'cmdline', -- for default cmdline
      },
      presets = {
        command_palette = true,
        lsp_doc_border = true,
        bottom_search = true,
        long_message_to_split = true,
      },
      lsp = {
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
        signature = {
          enabled = true,
          auto_open = {
            enabled = false,
          },
        },
      },
      routes = {
        {
          filter = {
            event = 'msg_show',
            any = {
              { find = '%d+L, %d+B' },
              { find = '; after #%d+' },
              { find = '; before #%d+' },
            },
          },
          view = 'mini',
        },
      },
    },
  },

  {
    'nvim-mini/mini.ai',
    modname = 'mini.ai',
    event = 'VeryLazy',
    deps = { 'folke/which-key.nvim' },
    opts = function()
      local ai = Pack.proxy 'mini.ai'
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter {
            a = { '@block.outer', '@conditional.outer', '@loop.outer' },
            i = { '@block.inner', '@conditional.inner', '@loop.inner' },
          },
          f = ai.gen_spec.treesitter { a = '@function.outer', i = '@function.inner' },
          c = ai.gen_spec.treesitter { a = '@class.outer', i = '@class.inner' },
          t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' },
          d = { '%f[%d]%d+' },
          e = {
            { '%u[%l%d]+%f[^%l%d]', '%f[%S][%l%d]+%f[^%l%d]', '%f[%P][%l%d]+%f[^%l%d]', '^[%l%d]+%f[^%l%d]' },
            '^().*()$',
          },
          g = Pack.proxy 'utils.plugins'.ai_buffer,
          u = ai.gen_spec.function_call(),
          U = ai.gen_spec.function_call { name_pattern = '[%w_]' },
        },
      }
    end,
    config = function(opts)
      require 'mini.ai'.setup(opts)
      local objects = {
        { ' ', desc = 'whitespace' },
        { '"', desc = '" string' },
        { "'", desc = "' string" },
        { '(', desc = '() block' },
        { ')', desc = '() block with ws' },
        { '<', desc = '<> block' },
        { '>', desc = '<> block with ws' },
        { '?', desc = 'user prompt' },
        { 'U', desc = 'use/call without dot' },
        { '[', desc = '[] block' },
        { ']', desc = '[] block with ws' },
        { '_', desc = 'underscore' },
        { '`', desc = '` string' },
        { 'a', desc = 'argument' },
        { 'b', desc = ')]} block' },
        { 'c', desc = 'class' },
        { 'd', desc = 'digit(s)' },
        { 'e', desc = 'CamelCase / snake_case' },
        { 'f', desc = 'function' },
        { 'g', desc = 'entire file' },
        { 'i', desc = 'indent' },
        { 'o', desc = 'block, conditional, loop' },
        { 'q', desc = 'quote `"\'' },
        { 't', desc = 'tag' },
        { 'u', desc = 'use/call' },
        { '{', desc = '{} block' },
        { '}', desc = '{} with ws' },
      }

      ---@type wk.Spec[]
      local ret = { mode = { 'o', 'x' } }
      ---@type table<string, string>
      local mappings = vim.tbl_extend('force', {}, {
        around = 'a',
        inside = 'i',
        around_next = 'an',
        inside_next = 'in',
        around_last = 'al',
        inside_last = 'il',
      }, opts.mappings or {})
      mappings.goto_left = nil
      mappings.goto_right = nil

      for name, prefix in pairs(mappings) do
        name = name:gsub('^around_', ''):gsub('^inside_', '')
        ret[#ret + 1] = { prefix, group = name }
        for _, obj in ipairs(objects) do
          local desc = obj.desc
          if prefix:sub(1, 1) == 'i' then
            desc = desc:gsub(' with ws', '')
          end
          ret[#ret + 1] = { prefix .. obj[1], desc = obj.desc }
        end
      end
      require 'which-key'.add(ret, { notify = false })
    end,
  },

}
