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

-- local cs = 'catppuccin'
local ok, _ = pcall(vim.cmd.colorscheme, cs or '')
if not ok then vim.cmd [[colo kanagawa]] end

require 'config.keymaps'
require 'lsp'
