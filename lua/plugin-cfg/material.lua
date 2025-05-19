local M = {}

-- If you decide to use opts, using init

M.init = function()
  vim.g.material_style = "deep ocean"
end

M.opts = {
  contrast = {
    terminal = false,              -- Enable contrast for the built-in terminal
    sidebars = false,              -- Enable contrast for sidebar-like windows ( for example Nvim-Tree )
    floating_windows = false,      -- Enable contrast for floating windows
    cursor_line = false,           -- Enable darker background for the cursor line
    lsp_virtual_text = false,      -- Enable contrasted background for lsp virtual text
    non_current_windows = false,   -- Enable contrasted background for non-current windows
    filetypes = {},                -- Specify which filetypes get the contrasted (darker) background
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
    -- "coc",
    -- "colorful-winsep",
    -- "dap",
    -- "dashboard",
    -- "eyeliner",
    -- "fidget",
    -- "flash",
    "gitsigns",
    -- "harpoon",
    -- "hop",
    -- "illuminate",
    -- "indent-blankline",
    -- "lspsaga",
    "mini",
    -- "neogit",
    -- "neotest",
    -- "neo-tree",
    -- "neorg",
    "noice",
    -- "nvim-cmp",
    "nvim-navic",
    "nvim-tree",
    "nvim-web-devicons",
    -- "rainbow-delimiters",
    -- "sneak",
    "telescope",
    "trouble",
    "which-key",
    -- "nvim-notify",
  },

  disable = {
    colored_cursor = true,
    background = true,
    borders = false,       -- Disable borders between vertically split windows
    term_colors = false,   -- Prevent the theme from setting terminal colors
    eob_lines = false,     -- Hide the end-of-buffer lines
  },

  high_visibility = {
    lighter = true,
    darker = true,
  },

  lualine_style = "default",   -- Lualine style ( can be 'stealth' or 'default' )

  async_loading = true,

  custom_colors = function(colors)
    colors.syntax.comments     = "#707070"
    colors.editor.border       = "#7D7D7D"
    colors.editor.line_numbers = "#555555"
    colors.git.added           = "#00A000"
    colors.git.removed         = "#BA0000"
    colors.git.modified        = "#0000FF"
  end,

  custom_highlights = {
    Pmenu = { bg = 'NONE' },
    StatusLine = { bg = 'NONE' },
    TabLineSel = function(colors, _)
      return { bold = true, }
    end
  },
}

M.config = function()
  vim.g.material_style = "deep ocean"
  require('material').setup({
    contrast = {
      terminal = false,            -- Enable contrast for the built-in terminal
      sidebars = false,            -- Enable contrast for sidebar-like windows ( for example Nvim-Tree )
      floating_windows = false,    -- Enable contrast for floating windows
      cursor_line = false,         -- Enable darker background for the cursor line
      lsp_virtual_text = false,    -- Enable contrasted background for lsp virtual text
      non_current_windows = false, -- Enable contrasted background for non-current windows
      filetypes = {},              -- Specify which filetypes get the contrasted (darker) background
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
      -- "coc",
      -- "colorful-winsep",
      -- "dap",
      -- "dashboard",
      -- "eyeliner",
      -- "fidget",
      -- "flash",
      "gitsigns",
      -- "harpoon",
      -- "hop",
      -- "illuminate",
      -- "indent-blankline",
      -- "lspsaga",
      "mini",
      -- "neogit",
      -- "neotest",
      -- "neo-tree",
      -- "neorg",
      "noice",
      -- "nvim-cmp",
      "nvim-navic",
      "nvim-tree",
      "nvim-web-devicons",
      -- "rainbow-delimiters",
      -- "sneak",
      "telescope",
      "trouble",
      "which-key",
      -- "nvim-notify",
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

    lualine_style = "default", -- Lualine style ( can be 'stealth' or 'default' )

    async_loading = true,

    custom_colors = function(colors)
      colors.syntax.comments     = "#707070"
      colors.editor.border       = "#7D7D7D"
      colors.editor.line_numbers = "#555555"
      colors.git.added           = "#00A000"
      colors.git.removed         = "#BA0000"
      colors.git.modified        = "#0000FF"
    end,

    custom_highlights = {
      Pmenu = { bg = 'NONE' },
      StatusLine = { bg = 'NONE' },
      TabLineSel = function(colors, _)
        return { bold = true, }
      end
    },
  })
end

return M
