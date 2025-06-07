local M = {}

---@diagnostic disable: missing-fields
---@type CatppuccinOptions
M.options = {
  flavour = "frappe",
  styles = {
    comments = { "italic" },
    keywords = { "italic" },
    conditionals = { "italic" },
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
        errors = { "undercurl" },
        hints = { "undercurl" },
        warnings = { "undercurl" },
        information = { "undercurl" },
      },
    },
    navic = { enabled = true, custom_bg = "lualine" },
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
    }
  end,
  transparent_background = true,
  term_colors = true,
  dim_inactive = { enabled = false },
}

M.spec = {
  {
    "akinsho/bufferline.nvim",
    optional = true,
    opts = function(_, opts)
      if (vim.g.colors_name or ""):find("catppuccin") then
        opts.highlights = require("catppuccin.groups.integrations.bufferline").get()
      end
    end,
  },
}
return M
