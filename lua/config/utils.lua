local M = {}

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
    return M.term_colorscheme()
  end
end

M.term_colorscheme = function()
  local terminal = os.getenv("TERM_PROGRAM")
  if terminal == "WezTerm" then
    --return "material"
    return "kanagawa"
  else
    return "kanagawa"
  end
end

M.custom_theme = function()
  local theme = {}
  local color = vim.g.colors_name
  if color and color:find("material") then
    theme = require('lualine.themes.palenight')
    local overrides = {
      normal = {
        a = { bg = '#82B1FF' }, -- blue
        b = { fg = '#82B1FF' },
      },
      insert = {
        a = { bg = '#C3E88D' }, -- green
        b = { fg = '#C3E88D' },
      },
      visual = {
        a = { bg = '#C792EA' }, -- purple
        b = { fg = '#C792EA' },
      },
      inactive = {
        a = { bg = '#82B1FF' },
        b = { fg = '#82B1FF' },
        c = { fg = '#697098', bg = '#292D3E' },
      },
    }
    for mode, sections in pairs(overrides) do
      theme[mode] = vim.tbl_deep_extend("force", theme[mode] or {}, sections)
    end
  elseif color and (color:find("kanagawa") or color:find("catppuccin")) then
    theme = require('lualine.themes.kanagawa')
  end
  for _, mode in pairs({ "normal", "insert", "visual", "inactive" }) do
    theme[mode] = theme[mode] or {}
    theme[mode].c = theme[mode].c or {}
    theme[mode].c.bg = 'NONE'
  end
  return theme
end


M.get_icon = function()
  local distro = "Arch"
  local handle = io.popen("cat /etc/*release 2>/dev/null | grep ^NAME=")
  if not handle then
    return "Arch"
  else
    distro = handle:read("*a")
    distro = distro:gsub('^NAME="?(.-)"?$', '%1')
    handle:close()
  end
  if distro:match("Ubuntu") then
    return ""
  elseif distro:match("Arch") then
    return ""
  elseif distro:match("Debian") then
    return ""
  elseif distro:match("Mint") then
    return "󰣭"
  end
  return ""
end

M.custom_foldtext = function()
  local line = vim.fn.getline(vim.v.foldstart)
  -- return vim.trim(line) .. " "
  local count = vim.v.foldend - vim.v.foldstart + 1
  return vim.trim(line) .. "  " .. count .. " lines "
end

return M
