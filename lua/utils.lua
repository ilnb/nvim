local M = {}

M.wm_colorscheme = function()
  local wm
  local handle = io.popen 'echo $XDG_SESSION_DESKTOP'
  if not handle then
    return 'Dunno'
  end
  wm = handle:read '*a':gsub('%s+', '')
  handle:close()
  if wm == 'Hyprland' then
    --return 'material'
    return 'kanagawa'
  else
    return M.term_colorscheme()
  end
end

M.term_colorscheme = function()
  local terminal = os.getenv 'TERM_PROGRAM'
  if terminal == 'WezTerm' then
    --return 'material'
    return 'kanagawa'
  else
    return 'kanagawa'
  end
end

M.lualine_theme = function()
  local theme = {}
  local color = vim.g.colors_name or ''
  if color:find 'kanagawa' then
    theme = require 'lualine.themes.kanagawa'
  elseif color:find 'catppuccin' then
    theme = require 'lualine.themes.catppuccin-mocha'
  elseif color:find 'kanso' then
    theme = require 'lualine.themes.kanso'
    local palette = require 'kanso.colors'.setup().palette

    ---@type fun(s:string, p:number):string
    local function darker(s, p)
      local r = tonumber(s:sub(2, 3), 16)
      local g = tonumber(s:sub(4, 5), 16)
      local b = tonumber(s:sub(6, 8), 16)
      p = 1 - p -- p% black
      local f = math.floor
      r = f(r * p + 0.5)
      g = f(g * p + 0.5)
      b = f(b * p + 0.5)
      return string.format('#%02X%02X%02X', r, g, b)
    end

    local overrides = {
      normal = {
        b = { bg = darker(palette.inkBlue2, 0.75) }
      },
      insert = {
        b = { bg = darker(palette.springGreen, 0.75) }
      },
      command = {
        b = { bg = darker(palette.inkGray2, 0.75) }
      },
      visual = {
        b = { bg = darker(palette.inkViolet, 0.75) }
      },
      replace = {
        b = { bg = darker(palette.inkOrange, 0.75) }
      },
    }
    for mode, sections in pairs(overrides) do
      theme[mode] = vim.tbl_deep_extend('force', theme[mode] or {}, sections)
    end
  else
    theme = require 'lualine.themes.palenight'
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
      replace = {
        a = { bg = '#FFA066' }, -- orange
        b = { fg = '#FFA066' },
      },
      inactive = {
        a = { bg = '#82B1FF' },
        b = { fg = '#82B1FF' },
        c = { fg = '#697098' },
      },
    }
    for mode, sections in pairs(overrides) do
      theme[mode] = vim.tbl_deep_extend('force', theme[mode] or {}, sections)
    end
  end
  for _, sections in pairs(theme) do
    sections.c = sections.c or {}
    sections.c.bg = 'NONE'
  end
  return theme
end

M.os_icon = function()
  local distro = 'Arch'
  local handle = io.popen 'cat /etc/*release 2>/dev/null | grep ^NAME='
  if not handle then
    return 'Arch'
  else
    distro = handle:read '*a'
    distro = distro:gsub('^NAME="?(.-)"?$', '%1')
    handle:close()
  end
  if distro:match 'Ubuntu' then
    return ''
  elseif distro:match 'Arch' then
    return ''
  elseif distro:match 'Fedora' then
    return ''
  elseif distro:match 'Debian' then
    return ''
  elseif distro:match 'Mint' then
    return '󰣭'
  end
  return ''
end

M.custom_foldtext = function()
  local line = vim.fn.getline(vim.v.foldstart)
  -- return vim.trim(line) .. " "
  local count = vim.v.foldend - vim.v.foldstart + 1
  return vim.trim(line) .. '  ' .. count .. ' lines '
end

return M
