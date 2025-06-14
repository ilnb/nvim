local M = {}

M.init = function()
  vim.g.navic_silence = true
  LazyVim.lsp.on_attach(function(client, buffer)
    -- no doc window _after_ typing function
    -- client.server_capabilities.signatureHelpProvider = nil
    if client:supports_method("textDocument/documentSymbol") then
      require("nvim-navic").attach(client, buffer)
    end
  end)
end

---@return Options
M.opts = function()
  return {
    separator = " ",
    highlight = true,
    depth_limit = 5,
    icons = LazyVim.config.icons.kinds,
    lazy_update_context = true,
  }
end

M.setup = function()
  M.init()
  local opts = M.opts()
  require('nvim-navic').setup(opts)
end

return M
