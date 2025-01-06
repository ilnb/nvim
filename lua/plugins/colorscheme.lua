return {
  -- default colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = 'material',
    }
  },

  -- catppuccin
  {
    "catppuccin/nvim",
    enabled = false,
  },

  -- tokyonight
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = { style = "night" },
  },

  -- kanagawa
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    config = function()
      require("kanagawa").setup({
        compile = false,
        undercurl = true, -- enable undercurls
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true },
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = false,   -- do not set background color
        dimInactive = false,   -- dim inactive window `:h hl-NormalNC`
        terminalColors = true, -- define vim.g.terminal_color_{0,17}
        colors = {             -- add/modify theme and palette colors
          palette = {},
          theme = {
            wave = {
              ui = { bg_gutter = "#1F1F28" },
            },
            dragon = {
              ui = { bg_gutter = "#181616" },
            },
          },
        },
        overrides = function(colors) -- add/modify highlights
          return {}
        end,
        theme = "wave", -- Load "wave" theme when 'background' option is not set
        background = {  -- map the value of 'background' option to a theme
          dark = "wave",
          light = "lotus",
        },
      })
    end,
  },

  -- material
  {
    "marko-cerovac/material.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.material_style = "deep ocean"
      require("material").setup({
        contrast = {
          terminal = false,            -- Enable contrast for the built-in terminal
          sidebars = false,            -- Enable contrast for sidebar-like windows ( for example Nvim-Tree )
          floating_windows = false,    -- Enable contrast for floating windows
          cursor_line = false,         -- Enable darker background for the cursor line
          lsp_virtual_text = false,    -- Enable contrasted background for lsp virtual text
          non_current_windows = false, -- Enable contrasted background for non-current windows
          filetypes = {},              -- Specify which filetypes get the contrasted (darker) background
        },

        styles = { -- Give comments style such as bold, italic, underline etc.
          comments = {
            italic = true,
          },
          strings = { --[[ bold = true ]]
          },
          keywords = {
            italic = true,
          },
          functions = { --[[ bold = true, undercurl = true ]]
          },
          variables = {},
          operators = {},
          types = {},
        },

        plugins = { -- Uncomment the plugins that you use to highlight them
          -- Available plugins:
          -- "coc",
          -- "colorful-winsep",
          -- "dap",
          "dashboard",
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
          "neo-tree",
          -- "neorg",
          "noice",
          "nvim-cmp",
          -- "nvim-navic",
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
          colored_cursor = true, -- Disable the colored cursor
          background = true,     -- Prevent the theme from setting the background (NeoVim then uses your terminal background)
          borders = false,       -- Disable borders between vertically split windows
          term_colors = false,   -- Prevent the theme from setting terminal colors
          eob_lines = false,     -- Hide the end-of-buffer lines
        },

        high_visibility = {
          lighter = true, -- Enable higher contrast text for lighter style
          darker = true,  -- Enable higher contrast text for darker style
        },

        lualine_style = "stealth", -- Lualine style ( can be 'stealth' or 'default' )

        async_loading = true,      -- Load parts of the theme asynchronously for faster startup (turned on by default)

        custom_colors = function(colors)
          colors.syntax.comments     = "#707070"
          colors.editor.border       = "#7D7D7D"
          colors.editor.line_numbers = "#555555"
          colors.git.added           = "#00A000"
          colors.git.removed         = "#BA0000"
          colors.git.modified        = "#0000FF"
        end,

        custom_highlights = {
          Pmenu = {
            bg = 'NONE',
          },
          TabLineSel = function(colors, _)
            return {
              bold = true,
            }
          end
        },
      })
    end,
  },
}
