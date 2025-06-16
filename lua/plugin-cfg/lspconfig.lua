local M = {}

local nosnippets = require('blink.cmp').get_lsp_capabilities({
  textDocument = {
    completion = {
      completionItem =
      {
        snippetSupport = false,
      },
    },
  },
})

---@param opts PluginLspOpts
M.opts = function(_, opts)
  local asm_lsp = {
    cmd = { 'asm-lsp' },
    filetypes = { 'asm', 's' },
    root_dir = function() return vim.fn.expand("~") end,
  }
  opts.servers["asm_lsp"] = asm_lsp
  opts.servers["clangd"].capabilities = vim.tbl_deep_extend("force", opts.servers["clangd"].capabilities, nosnippets)

  -- local servers = { "asm_lsp", "clangd", "lua_ls", "pyright", "zls" }
  -- for _, lsp in ipairs(servers) do
  --   opts.servers[lsp] = opts.servers[lsp] or {}
  --   opts.servers[lsp].capabilities = vim.tbl_deep_extend("force", opts.servers[lsp].capabilities or {}, capabilities)
  -- end
end

return M
