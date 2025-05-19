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
  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = wm_colorscheme()
      colorscheme = "kanagawa",
    },
  },

  {
    "nvim/catppuccin",
  },

  {
    "rebelot/kanagawa.nvim",
    config = function() require('plugin-cfg.kanagawa').config() end
  },

  {
    "marko-cerovac/material.nvim",
    config = function() require('plugin-cfg.material').config() end
    -- init = function() require('plugin-cfg.material').init() end,
    -- opts = function() return require('plugin-cfg.material').opts end
  },

  {
    "folke/tokyonight.nvim",
    opts = { style = "night" },
  },
}
