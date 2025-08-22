return {
  'webhooked/kanso.nvim',
  priority = 1000,
  config = function()
    require 'kanso'.setup {
      compile = false,
      bold = true,
      italics = true,
      undercurl = true, -- enable undercurls
      commentStyle = { italic = true },
      functionStyle = {},
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      typeStyle = {},
      transparent = true,
      dimInactive = false,   -- dim inactive window `:h hl-NormalNC`
      terminalColors = true, -- define vim.g.terminal_color_{0,17}

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
        }
      end,

      theme = 'mist',
      background = { dark = 'mist', light = 'mist' },
    }
  end
}
