require 'config.options'
require 'config.lazy'

local cs = ''
cs = 'vague'
local ok, _ = pcall(vim.cmd.colorscheme, cs)
if not ok then vim.cmd [[colo kanagawa]] end

require 'config.keymaps'
require 'config.autocmds'
require 'lsp'
