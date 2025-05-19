local M = {}

M.term_colorscheme = function()
  local terminal = os.getenv("TERM_PROGRAM")
  if terminal == "WezTerm" then
    --return "material"
    return "kanagawa"
  else
    return "kanagawa"
  end
end

M.wm_colorscheme = function()
  local wm
  local handle = io.popen("echo $XDG_SESSION_DESKTOP")
  if not handle then
    return "Dunno"
  end
  wm = handle:read("*a"):gsub("%s+", "")
  handle:close()
  if wm == "Hyprland" then
    --return "material"
    return "kanagawa"
  else
    return term_colorscheme()
  end
end

return M
