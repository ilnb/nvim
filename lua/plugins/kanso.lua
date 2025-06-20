return {
  'webhooked/kanso.nvim',
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

      ---@type fun(colors: KanagawaColorsSpec): table<string, table>
      overrides = function(colors)
        return {
          GitSignsAdd = { fg = '#00A000' },
          GitSignsChange = { fg = '#0000FF' },
          GitSignsDelete = { fg = '#BA0000' },
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
        }
      end,

      theme = 'zen',
      background = { dark = 'zen', light = 'mist' },
    }
  end

}
