---@diagnostic disable:undefined-doc-name, undefined-field, inject-field
return {
  {
    'rebelot/kanagawa.nvim',
    config = function()
      require 'kanagawa'.setup {
        compile = false,
        undercurl = true,
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = false },
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = true,
        dimInactive = false,
        terminalColors = true,

        colors = {
          palette = {},
          theme = {
            all = {
              ui = {
                bg_gutter = 'NONE',
                float = { bg_border = 'NONE', },
              },
            },
          },
        },

        ---@type fun(colors: KanagawaColorsSpec): table<string, table>
        overrides = function(colors)
          return {
            NavicText = { fg = colors.palette.fujiWhite },
            Pmenu = { bg = 'NONE' },
            CursorLine = { bg = 'NONE' },
            NormalFloat = { bg = 'NONE' },
            FloatBorder = { bg = 'NONE' },
            MiniFilesCursorLine = { link = 'PmenuSel' },
            MiniFilesTitleFocused = { fg = '#F9E2AF' },
            StatusLine = { bg = 'NONE' },
            TabLineFill = { bg = 'NONE' },
            UfoFoldedBg = { bg = 'NONE' },      -- doesn't work
            UfoPreviewWin = { bg = '#5A6FAF' }, -- same here
            Whitespace = { fg = '#33334A' },
            BlinkCmpSource = { link = 'Special' },
            String = { italic = true },
            ['@lsp.typemod.variable.fileScope.cpp'] = { link = '@lsp.typemod.variable.defaultLibrary.cpp' },
          }
        end,

        theme = 'wave',
        background = { dark = 'wave', light = 'wave' },
      }
    end
  },

  {
    'vague-theme/vague.nvim',
    -- enabled = false,
    config = function()
      require 'vague'.setup {
        transparent = true,
        bold = true,
        italic = true,
        style = {
          -- 'none' == default
          comments = 'italic',
          strings = 'italic',
          keywords = 'none',
          keyword_return = 'italic',
          keywords_loop = 'none',
          keywords_label = 'bold',
          keywords_exception = 'none',
          builtin_constants = 'bold',
          builtin_functions = 'none',
          builtin_types = 'none',
          builtin_variables = 'none',
        },
        plugins = {
          blink = {
            match = 'bold',
            match_fuzzy = 'bold',
          },
          lsp = {
            diagnostic_error = 'bold',
            diagnostic_hint = 'italic',
            diagnostic_info = 'italic',
            diagnostic_warn = 'bold',
          },
        },
        -- very weak
        on_highlights = function(hi, col)
          hi.Pmenu = { bg = 'NONE' }
          hi.CursorLine = { bg = 'NONE' }
          hi.NormalFloat = { bg = 'NONE' }
          hi.FloatBorder = { bg = 'NONE' }
          hi.StatusLine = { bg = 'NONE' }
          hi.TabLineFill = { bg = 'NONE' }
        end,
        colors = {
          bg = '#141415',
          inactiveBg = '#1c1c24',
          fg = '#cdcdcd',
          floatBorder = '#878787',
          line = '#252530',
          comment = '#606079',
          builtin = '#b4d4cf',
          func = '#c48282',
          string = '#e8b589',
          number = '#e0a363',
          property = '#c3c3d5',
          constant = '#aeaed1',
          parameter = '#bb9dbd',
          visual = '#333738',
          error = '#d8647e',
          warning = '#f3be7c',
          hint = '#7e98e8',
          operator = '#90a0b5',
          keyword = '#6e94b2',
          type = '#9bb4bc',
          search = '#405065',
          plus = '#7fa563',
          delta = '#f3be7c',
        },
      }

      vim.defer_fn(function()
        for grp, opt in pairs {
          BlinkCmpSource = { link = 'Special' },
          BlinkCmpMenuSelection = { bg = vim.api.nvim_get_hl(0, { name = 'IncSearch' }).bg },
        } do
          vim.api.nvim_set_hl(0, grp, opt)
        end
      end, 0.1)
    end,
  },

  {
    'webhooked/kanso.nvim',
    enabled = false,
    config = function()
      require 'kanso'.setup {
        compile = false,
        bold = true,
        italics = true,
        undercurl = true,
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true },
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = true,
        dimInactive = false,
        terminalColors = true,

        colors = {
          palette = {},
          theme = {
            all = {
              ui = {
                bg_gutter = 'NONE',
                float = { bg_border = 'NONE', },
              },
            },
          },
        },

        ---@type fun(colors: KansoColorsSpec): table<string, table>
        overrides = function(colors)
          return {
            NavicText = { fg = colors.palette.pearlWhite0 },
            Pmenu = { bg = 'NONE' },
            CursorLine = { bg = 'NONE' },
            NormalFloat = { bg = 'NONE' },
            FloatBorder = { bg = 'NONE' },
            MiniFilesCursorLine = { link = 'PmenuSel' },
            StatusLine = { bg = 'NONE' },
            TabLineFill = { bg = 'NONE' },
            UfoFoldedBg = { bg = 'NONE' },      -- doesn't work
            UfoPreviewWin = { bg = '#5A6FAF' }, -- same here
            Whitespace = { fg = '#33334A' },
            BlinkCmpSource = { link = 'Special' },
            String = { italic = true },
            ['@lsp.typemod.variable.fileScope.cpp'] = { link = '@lsp.typemod.variable.defaultLibrary.cpp' },
          }
        end,

        theme = 'mist',
        background = { dark = 'mist', light = 'mist' },
      }
    end
  },

  {
    'catppuccin/nvim',
    enabled = false,
    name = 'catppuccin',
    ---@type CatppuccinOptions
    opts = {
      flavour = 'frappe',
      styles = {
        comments = { 'italic' },
        keywords = { 'italic' },
        conditionals = { 'italic' },
        loops = {},
        functions = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
      },

      integrations = {
        blink_cmp = true,
        flash = true,
        fzf = true,
        gitsigns = true,
        mason = true,
        markdown = true,
        mini = true,

        native_lsp = {
          enabled = true,
          underlines = {
            errors = { 'undercurl' },
            hints = { 'undercurl' },
            warnings = { 'undercurl' },
            information = { 'undercurl' },
          },
        },

        navic = { enabled = true, custom_bg = 'NONE' },
        neotree = true,
        noice = true,
        snacks = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },

      custom_highlights = function()
        return {
          GitSignsAdd = { fg = '#00A000' },
          GitSignsChange = { fg = '#0000FF' },
          GitSignsDelete = { fg = '#BA0000' },
          Pmenu = { bg = 'NONE' },
          PmenuSel = { bg = '#2D4F67' },
          BlinkCmpMenuSelection = { link = 'PmenuSel' },
          BlinkCmpSource = { link = 'Special' },
          MiniFilesCursorLine = { link = 'PmenuSel' },
          CursorLine = { bg = 'NONE' },
          NormalFloat = { bg = 'NONE' },
          MiniFilesTitleFocused = { fg = '#F9E2AF' },
          FloatBorder = { bg = 'NONE' },
          StatusLine = { bg = 'NONE' },
          TabLineFill = { bg = 'NONE' },
          ['@lsp.typemod.variable.fileScope.cpp'] = { link = '@lsp.typemod.variable.defaultLibrary.cpp' },
        }
      end,

      transparent_background = true,
      term_colors = true,
      dim_inactive = { enabled = false },
    },

    spec = {
      {
        'akinsho/bufferline.nvim',
        optional = true,
        opts = function(_, opts)
          if (vim.g.colors_name or ''):find 'catppuccin' then
            opts.highlights = require 'catppuccin.groups.integrations.bufferline'.get()
          end
        end,
      },
    }
  },

  {
    'marko-cerovac/material.nvim',
    enabled = false,
    config = function()
      vim.g.material_style = 'deep ocean'
      require 'material'.setup {
        contrast = {
          terminal = false,
          sidebars = false,
          floating_windows = false,
          cursor_line = false,
          lsp_virtual_text = false,
          non_current_windows = false,
          filetypes = {},
        },

        styles = {
          comments = { italic = true, },
          strings = {},
          keywords = { italic = true, },
          functions = {},
          variables = {},
          operators = {},
          types = {},
        },

        plugins = {
          -- Available plugins:
          'blink',
          -- 'coc',
          -- 'colorful-winsep',
          'dap',
          -- 'dashboard',
          -- 'eyeliner',
          -- 'fidget',
          'flash',
          'gitsigns',
          -- 'harpoon',
          -- 'hop',
          -- 'illuminate',
          -- 'indent-blankline',
          -- 'lspsaga',
          'mini',
          -- 'neogit',
          -- 'neotest',
          -- 'neo-tree',
          -- 'neorg',
          'noice',
          -- 'nvim-cmp',
          'nvim-navic',
          -- 'nvim-tree',
          -- 'nvim-web-devicons',
          -- 'rainbow-delimiters',
          -- 'sneak',
          -- 'telescope',
          -- 'trouble',
          'which-key',
          -- 'nvim-notify',
        },

        disable = {
          colored_cursor = true,
          background = true,
          borders = false,     -- Disable borders between vertically split windows
          term_colors = false, -- Prevent the theme from setting terminal colors
          eob_lines = false,   -- Hide the end-of-buffer lines
        },

        high_visibility = {
          lighter = true,
          darker = true,
        },

        lualine_style = 'default', -- Lualine style ( can be 'stealth' or 'default' )

        async_loading = true,

        custom_colors = function(colors)
          colors.syntax.comments     = '#707070'
          colors.editor.border       = '#7D7D7D'
          colors.editor.line_numbers = '#555555'
          colors.git.added           = '#00A000'
          colors.git.removed         = '#BA0000'
          colors.git.modified        = '#0000FF'
        end,

        custom_highlights = function()
          local groups = require 'material.highlights.plugins.nvim-navic'.load()
          local t = {}
          for group, cfg in pairs(groups) do
            t[group] = cfg
            if t[group].bg then
              t[group].bg = 'NONE'
            end
          end
          return vim.tbl_deep_extend('force', t, {
            Pmenu = { bg = 'NONE' },
            StatusLine = { bg = 'NONE' },
            TabLineSel = { bold = true },
            ['@attribute.c'] = { link = 'Constant' },
            Search = { bg = '#404040' },
            IncSearch = { bg = '#404040' },
            CurSearch = { bg = '#797960', fg = '#212C64' },
            Whitespace = { fg = '#2C2C43' },
            CursorLine = { bg = 'NONE' },
            MiniFilesCursorLine = { bg = '#404040' },
            BlinkCmpSource = { link = 'Special' },
            ['@lsp.typemod.variable.fileScope.cpp'] = { link = '@lsp.typemod.variable.defaultLibrary.cpp' },
          })
        end,
      }
    end
  },

  {
    'folke/tokyonight.nvim',
    enabled = false,
    opts = {
      style = 'night',
      transparent = true,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        conditionals = { italic = true },
        loops = {},
        functions = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
        sidebars = 'dark',
        floats = 'dark',
      },
      dim_inactive = false,
      lualine_bold = false,
      cache = true,
      plugins = {
        blink = true,
        bufferline = true,
        flash = true,
        fzf = true,
        gitsigns = true,
        ['indent-blankline'] = true,
        mini_files = true,
        mini_surround = true,
        navic = true,
        noice = true,
        ['render-markdown'] = true,
        snacks = true,
        ['which-key'] = true,
      },

      ---@param colors ColorScheme
      on_colors = function(colors)
        colors.border       = '#7D7D7D'
        colors.git.added    = '#00A000'
        colors.git.removed  = '#BA0000'
        colors.git.modified = '#0000FF'
      end,

      ---@param hi tokyonight.Highlights
      ---@param colors ColorScheme
      on_highlights = function(hi, colors)
        hi.GitSignsAdd = { fg = '#00A000' }
        hi.GitSignsChange = { fg = '#0000FF' }
        hi.GitSignsDelete = { fg = '#BA0000' }
        hi.Pmenu = { bg = 'NONE' }
        hi.PmenuSel = { bg = '#2D4F67' }
        hi.BlinkCmpMenuSelection = { link = 'PmenuSel' }
        hi.BlinkCmpSource = { link = 'Special' }
        hi.CursorLine = { bg = 'NONE' }
        hi.NormalFloat = { bg = 'NONE' }
        hi.FloatBorder = { bg = 'NONE' }
        hi.StatusLine = { bg = 'NONE' }
        hi.TabLineFill = { bg = 'NONE' }
        hi.LspInlayHint = { link = 'NonText' }
        hi['@lsp.typemod.variable.fileScope.cpp'] = { link = '@lsp.typemod.variable.defaultLibrary.cpp' }
      end,
    },
  },

}
