local servers = {
  'asm_lsp',
  'basedpyright',
  'clangd',
  'gopls',
  'lua_ls',
  -- 'pyright',
  'zls',
}

for _, server in pairs(servers) do
  local ok, cfg = pcall(require, 'lsp.' .. server)
  cfg = ok and cfg or {}
  cfg.on_attach = cfg.on_attach or require 'utils.lsp'.on_attach
  cfg.capabilities = cfg.capabilities or require 'utils.lsp'.capabilities

  vim.lsp.config(server, cfg)
  vim.lsp.enable(server)
end
