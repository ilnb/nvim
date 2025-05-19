local M = {}

-- NOTE: everything other than init.lua

-- local plugin_dir = vim.fn.stdpath("config") .. "/lua/plugins"
-- local plugin_files = vim.fn.globpath(plugin_dir, "*.lua", false, true)
--
-- for _, file in ipairs(plugin_files) do
--   local name = vim.fn.fnamemodify(file, ":t:r") -- extract filename without extension
--   if name ~= "init" then
--     local ok, plugin = pcall(require, "plugins." .. name)
--     if ok then
--       vim.list_extend(M, plugin)
--     else
--       vim.notify("Error loading plugins." .. name .. ": " .. plugin, vim.log.levels.ERROR)
--     end
--   end
-- end

-- PERF: this gives more control
vim.list_extend(M, require('plugins.colorscheme'))
vim.list_extend(M, require('plugins.ui'))
vim.list_extend(M, require('plugins.coding'))
vim.list_extend(M, require('plugins.disabled'))
vim.list_extend(M, require('plugins.files'))

return M
