---@diagnostic disable:undefined-global
vim.loader.enable()

require 'config.globals'
require 'config.options'

local pack_mode = true

if pack_mode then
  _G.Pack = require 'config.pack-setup'
  require 'config.pack'
else
  require 'config.lazy'
end

require 'config.autocmds'

local default = 'kanagawa'
-- local override = 'catppuccin'
local cs = override or default
Pack.load_plugin(Pack.mod_to_spec[cs])
vim.cmd.colo(cs)

require 'config.keymaps'
require 'lsp'
