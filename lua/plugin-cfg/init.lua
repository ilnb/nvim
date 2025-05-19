-- not using init.lua for now
if true then return {} end

local M = {}

-- NOTE: This causes disabled configs to load

local cfg_dir = vim.fn.stdpath("config") .. "/lua/plugin-cfg"
local cfg_files = vim.fn.globpath(cfg_dir, "*.lua", false, true)

for _, file in ipairs(cfg_files) do
  local name = vim.fn.fnamemodify(file, ":t:r") -- extract filename without extension
  if name ~= "init" and name ~= "example" then
    local ok, plugin = pcall(require, "plugin-cfg." .. name)
    if ok then
      M[name] = plugin
    else
      vim.notify("Error loading plugins." .. name .. ": " .. plugin, vim.log.levels.ERROR)
    end
  end
end

return M
