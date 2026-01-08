return {
  {
    'rebelot/kanagawa.nvim',
    config = function()
      require 'kanagawa'.setup {
        compile = false,
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
            ['@lsp.typemod.variable.fileScope.cpp'] = { link = '@lsp.typemod.variable.defaultLibrary.cpp' },
          }
        end,

        theme = 'wave',
        background = { dark = 'wave', light = 'wave' },
      }
    end
  },

  {
    'masisz/wisteria.nvim',
    enabled = false,
    opts = {
      transparent = true,
      ---@type fun(colors:WisteriaColors):HighlightSpec
      overrides = function(colors)
        local keyword = vim.api.nvim_get_hl(0, { name = '@keyword' })
        local property = vim.api.nvim_get_hl(0, { name = '@property' })

        ---@param c integer?
        ---@param p number
        ---@return integer?
        local function darker(c, p)
          if not c then return nil end
          p = 1 - p

          local bd = bit.band
          local f = math.floor

          local r = bd(bit.rshift(c, 16), 0xFF)
          local g = bd(bit.rshift(c, 8), 0xFF)
          local b = bd(c, 0xFF)

          r = f(r * p + 0.5)
          g = f(g * p + 0.5)
          b = f(b * p + 0.5)

          return bit.lshift(r, 16) + bit.lshift(g, 8) + b
        end

        ---@type table<string, vim.api.keyset.highlight>
        return {
          CursorLine = { bg = 'NONE' },
          Function = { fg = 'NvimLightRed' },
          Whitespace = { fg = '#33334A' },
          Visual = { bg = darker(property.fg, 0.5) },
          LineNr = { fg = '#44445D' },
          Comment = { fg = '#67678D', italic = true },
          ['@keyword.function'] = { fg = keyword.fg },
          ['@lsp.typemod.variable.fileScope.cpp'] = { link = '@lsp.typemod.variable.defaultLibrary.cpp' },
        }
      end
    },
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
    ---@diagnostic disable: missing-fields
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

      ---@param highlights tokyonight.Highlights
      ---@param colors ColorScheme
      on_highlights = function(highlights, colors)
        highlights.GitSignsAdd = { fg = '#00A000' }
        highlights.GitSignsChange = { fg = '#0000FF' }
        highlights.GitSignsDelete = { fg = '#BA0000' }
        highlights.Pmenu = { bg = 'NONE' }
        highlights.PmenuSel = { bg = '#2D4F67' }
        highlights.BlinkCmpMenuSelection = { link = 'PmenuSel' }
        highlights.CursorLine = { bg = 'NONE' }
        highlights.NormalFloat = { bg = 'NONE' }
        highlights.FloatBorder = { bg = 'NONE' }
        highlights.StatusLine = { bg = 'NONE' }
        highlights.TabLineFill = { bg = 'NONE' }
        highlights.LspInlayHint = { link = 'NonText' }
        highlights['@lsp.typemod.variable.fileScope.cpp'] = { link = '@lsp.typemod.variable.defaultLibrary.cpp' }
      end,
    },
  },

}
