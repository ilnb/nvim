---@diagnostic disable:undefined-global
vim.loader.enable()

require 'config.globals'
NeoVim.pack_mode = true

require 'config.options'

if NeoVim.pack_mode then
  require 'config.pack'
else
  require 'config.lazy'
end

local default = 'kanagawa'
local override = 'gruvbox-material'
local cs = override or default
NeoVim.color_scheme = cs
NeoVim.load(cs)
vim.cmd.colo(cs)

require 'config.autocmds'

require 'config.keymaps'
require 'lsp'
