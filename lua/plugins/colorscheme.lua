local function term_colorscheme()
  local terminal = os.getenv("TERM_PROGRAM")
  if terminal == "WezTerm" then
    --return "material"
    return "kanagawa"
  else
    return "kanagawa"
  end
end

local function get_wm()
  local handle = io.popen("echo $XDG_SESSION_DESKTOP")
  if not handle then
    return "Dunno"
  end
  local wm = handle:read("*a"):gsub("%s+", "")
  handle:close()
  return wm
end

local function wm_colorscheme()
  local wm = get_wm()
  if wm == "Hyprland" then
    --return "material"
    return "kanagawa"
  else
    return term_colorscheme()
  end
end

return {
  -- default colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = wm_colorscheme(),
    }
  },

  -- catppuccin
  {
    "nvim/catppuccin",
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
        transparent = true,
        dimInactive = false,   -- dim inactive window `:h hl-NormalNC`
        terminalColors = true, -- define vim.g.terminal_color_{0,17}
        colors = {
          palette = {},
          theme = {
            wave = {
              ui = {
                bg_gutter = 'NONE',
                -- bg_m3 = 'NONE', -- messes with mutliple things, along with stl
                float = {
                  bg_border = 'NONE',
                },
              },
            },
            dragon = {
              bg_gutter = 'NONE',
            },
          },
        },
        overrides = function(colors) -- add/modify highlights
          return {
            GitSignsAdd = { fg = '#00A000' },
            GitSignsChange = { fg = '#0000FF' },
            GitSignsDelete = { fg = '#BA0000' },
            Pmenu = { bg = 'NONE' },
            CursorLine = { bg = 'NONE' },
            NormalFloat = { bg = 'NONE' },
            FloatBorder = { bg = 'NONE' },
            MiniFilesCursorLine = { link = 'BlinkCmpMenuSelection' },
            StatusLine = { bg = 'NONE' },
          }
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
    lazy = true,
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

        styles = {
          comments = {
            italic = true,
          },
          strings = {},
          keywords = {
            italic = true,
          },
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
            return {
              bold = true,
            }
          end
        },
      })
    end,
  },
}
