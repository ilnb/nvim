return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',

  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      -- set an empty statusline till lualine loads
      vim.o.statusline = ' '
    else
      -- hide the statusline on the starter page
      vim.o.laststatus = 0
    end
  end,

  opts = function()
    -- PERF: we don't need this lualine require madness 🤷
    require 'lualine_require'.require = require
    vim.o.laststatus = vim.g.lualine_laststatus

    vim.api.nvim_create_autocmd('ColorScheme', {
      callback = function()
        require 'lualine'.setup {
          options = { theme = require 'utils.plugins'.lualine_theme() },
        }
      end
    })

    local opts = {
      options = {
        theme = require 'utils.plugins'.lualine_theme(),
        globalstatus = vim.o.laststatus == 3,
        disabled_filetypes = { statusline = { 'dashboard', 'alpha', 'ministarter', 'snacks_dashboard' } },
      },

      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch' },

        lualine_c = {
          {
            'diagnostics',
            symbols = {
              error = ' ',
              warn  = ' ',
              info  = ' ',
              hint  = ' ',
            },
          },

          {
            'filetype',
            icon_only = true,
            separator = '',
            padding = { left = 1, right = 0 }
          },

          'filename',
          {
            function()
              local navic = require 'nvim-navic'
              return navic.get_location()
            end,
            cond = function()
              local ok, navic = pcall(require, 'nvim-navic')
              return ok and navic.is_available()
            end,
            color = 'dynamic',
          }
        },

        lualine_x = {
          Snacks.profiler.status(),
          {
            function() return require 'noice'.api.status.command.get() end,
            cond = function() return package.loaded['noice'] and require 'noice'.api.status.command.has() end,
            color = function() return { fg = Snacks.util.color 'Statement' } end,
          },

          {
            function() return require 'noice'.api.status.mode.get() end,
            cond = function() return package.loaded['noice'] and require 'noice'.api.status.mode.has() end,
            color = function() return { fg = Snacks.util.color 'Constant' } end,
          },

          {
            function() return '  ' .. require 'dap'.status() end,
            cond = function() return package.loaded['dap'] and require 'dap'.status() ~= '' end,
            color = function() return { fg = Snacks.util.color 'Debug' } end,
          },

          {
            require 'lazy.status'.updates,
            cond = require 'lazy.status'.has_updates,
            color = function() return { fg = Snacks.util.color 'Special' } end,
          },

          {
            'diff',
            symbols = {
              added = '+',
              modified = '~',
              removed = '-',
            },

            -- separator = "",
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
          },

          {
            function() return require 'utils.plugins'.os_icon() end
          }
        },

        lualine_y = {
          {
            'progress',
            separator = ' ',
            padding = { left = 1, right = 0 },
          },

          {
            'location',
            padding = { left = 0, right = 1 },
          },
        },

        lualine_z = {
          function()
            return ' ' .. os.date '%R'
          end,
        },
      },
      extensions = { 'fzf', 'lazy', 'mason' },
    }

    return opts
  end
}
