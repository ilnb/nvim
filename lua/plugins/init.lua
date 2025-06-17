local M = {}

-- ---@type fun(mod: string): boolean
-- local function in_disabled(mod)
--   for _, spec in ipairs(disabled) do
--     local plugin = spec.name or vim.fn.fnamemodify(spec[1], ':t'):gsub('%.nvim$', '')
--     if plugin == mod then
--       return spec.enabled == false
--     end
--   end
--   return false
-- end
--
-- local disabled = require('plugins.disabled')
-- vim.list_extend(M, disabled)
--
-- local plugin_dir = vim.fn.stdpath('config') .. '/lua/plugins'
-- local plugin_files = vim.fn.globpath(plugin_dir, '*.lua', false, true)
-- for _, file in ipairs(plugin_files) do
--   local name = vim.fn.fnamemodify(file, ':t:r')
--   if name ~= 'init' and name ~= 'disabled' and not in_disabled(name) then
--     local ok, plugin = pcall(require, 'plugins.' .. name)
--     if ok then
--       table.insert(M, plugin)
--       -- vim.list_extend(M, type(plugin[1]) == "table" and plugin or { plugin })
--     else
--       vim.notify('Error loading plugins.' .. name .. ': ' .. plugin, vim.log.levels.ERROR)
--     end
--   end
-- end

return M
