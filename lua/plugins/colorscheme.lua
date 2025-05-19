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
    opts = { colorscheme = wm_colorscheme() }
  },

  {
    "nvim/catppuccin",
  },

  {
    "rebelot/kanagawa.nvim",
    config = require('plugin-cfg.kanagawa').config
  },

  {
    "marko-cerovac/material.nvim",
    config = require('plugin-cfg.material').config
    -- init = require('plugin-cfg.material').init,
    -- opts = require('plugin-cfg.material').opts
  },

  {
    "folke/tokyonight.nvim",
    opts = { style = "night" },
  },
}
