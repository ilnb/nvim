return {
  {
    'echasnovski/mini.surround',
    event = 'InsertEnter',
    keys = {
      { 'gsa', desc = 'Add Surrounding',       mode = { 'n', 'v' } },
      { 'gsd', desc = 'Delete Surrounding' },
      { 'gsf', desc = 'Find Right Surrounding' },
      { 'gsF', desc = 'Find Left Surrounding' },
      { 'gsh', desc = 'Highlight Surrounding' },
      { 'gsr', desc = 'Replace Surrounding' },
      { 'gsn', desc = 'Update n_lines' },
    },
    opts = {
      mappings = {
        add = 'gsa',
        delete = 'gsd',
        find = 'gsf',
        find_left = 'gsF',
        highlight = 'gsh',
        replace = 'gsr',
        update_n_lines = 'gsn',
      },
      n_lines = 40,
    },
  },

  {
    'echasnovski/mini.pairs',
    event = { 'InsertEnter', 'CmdLineEnter' },
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
    event = 'VeryLazy',
    vscode = true,
    ---@type Flash.Config
    ---@diagnostic disable-next-line: missing-fields
    opts = {},
    keys = {
      { 's',     mode = { 'n', 'x', 'o' }, function() require 'flash'.jump() end,              desc = 'Flash' },
      { 'S',     mode = { 'n', 'o', 'x' }, function() require 'flash'.treesitter() end,        desc = 'Flash Treesitter' },
      { 'r',     mode = 'o',               function() require 'flash'.remote() end,            desc = 'Remote Flash' },
      { 'R',     mode = { 'o', 'x' },      function() require 'flash'.treesitter_search() end, desc = 'Treesitter Search' },
      { '<c-s>', mode = { 'c' },           function() require 'flash'.toggle() end,            desc = 'Toggle Flash Search' },
    },
  },

  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts_extend = { 'spec' },
    opts = {
      preset = 'helix',
      spec = {
        { '<BS>',      desc = 'Decrement Selection', mode = 'x' },
        { '<c-space>', desc = 'Increment Selection', mode = { 'x', 'n' } },
        {
          mode = { 'n', 'v' },
          { '<leader>t', group = 'tabs' },
          { '<leader>c', group = 'code' },
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
              return require 'which-key.extras'.expand.buf()
            end,
          },
          {
            '<leader>w',
            group = 'windows',
            proxy = '<c-w>',
            expand = function()
              return require 'which-key.extras'.expand.win()
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
          require 'which-key'.show { global = true }
        end,
        desc = 'Buffer Keymaps (which-key)',
      },
      {
        '<c-w><space>',
        function()
          require 'which-key'.show { keys = '<c-w>', loop = true }
        end,
        desc = 'Window Hydra Mode',
      },
      {
        '<space>b<space>',
        function()
          require 'which-key'.show { keys = '<space>b', loop = true }
        end,
        desc = 'Buffer Hydra Mode',
      }
    },
    config = function(_, opts)
      require 'which-key'.setup(opts)
    end,
  },

  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
      { 'MunifTanjim/nui.nvim' },
    },
    keys = {
      { '<leader>sn',  '',                                       desc = '+noice' },
      -- { '<leader>snl', function() require 'noice'.cmd 'last' end,    desc = 'Noice Last Message' },
      -- { '<leader>snh', function() require 'noice'.cmd 'history' end, desc = 'Noice History' },
      { '<leader>sna', function() require 'noice'.cmd 'all' end, desc = 'Noice All' },
      -- { '<leader>snd', function() require 'noice'.cmd 'dismiss' end, desc = 'Dismiss All' },
      -- { '<leader>snt', function() require 'noice'.cmd 'pick' end,    desc = 'Noice Picker (Telescope/FzfLua)' },
      {
        '<c-f>',
        function() if not require 'noice.lsp'.scroll(4) then return '<c-f>' end end,
        silent = true,
        expr = true,
        desc = 'Scroll Forward',
        mode = { 'i', 'n', 's' }
      },
      {
        '<c-b>',
        function() if not require 'noice.lsp'.scroll(-4) then return '<c-b>' end end,
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
          scrollbar = false,
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

    config = function(_, opts)
      if vim.o.filetype == 'lazy' then
        vim.cmd [[messages clear]]
      end
      require 'noice'.setup(opts)
    end
  },

  {
    'echasnovski/mini.ai',
    event = 'VeryLazy',
    dependencies = { 'folke/which-key.nvim' },
    opts = function()
      local ai = require 'mini.ai'
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
          g = require 'utils.plugins'.ai_buffer,
          u = ai.gen_spec.function_call(),
          U = ai.gen_spec.function_call { name_pattern = '[%w_]' },
        },
      }
    end,
    config = function(_, opts)
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
  }
}
