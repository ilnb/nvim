local M = {}

---@param opts PluginLspOpts
M.opts = function(_, opts)
  local asm = {
    cmd = { 'asm-lsp' },
    filetypes = { 'asm', 's' },
    root_dir = function() return vim.fn.expand("~") end
  }
  opts.servers["asm_lsp"] = asm
end

return M
