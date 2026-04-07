require 'config.globals'
require 'config.options'
-- require 'config.lazy'
require 'config.pack'

local cs = ''
-- cs = 'catppuccin'
local ok, _ = pcall(vim.cmd.colorscheme, cs)
if not ok then vim.cmd [[colo kanagawa]] end

require 'config.keymaps'
require 'config.autocmds'
require 'lsp'
