---@diagnostic disable:undefined-global
vim.loader.enable()

require 'config.globals'
NeoVim.pack_mode = true

require 'config.options'

if NeoVim.pack_mode then
  _G.Pack = require 'config.pack-setup'
  require 'config.pack'
else
  require 'config.lazy'
end

require 'config.autocmds'

local default = 'kanagawa'
-- local override = 'catppuccin'
local cs = override or default
if NeoVim.pack_mode then
  Pack.load(cs)
end
vim.cmd.colo(cs)

require 'config.keymaps'
require 'lsp'
