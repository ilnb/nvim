_G.servers = {
  asm_lsp      = { 'asm' },
  basedpyright = { 'python' },
  clangd       = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
  gopls        = { 'go' },
  lua_ls       = { 'lua' },
  zls          = { 'zig' },
}

for server, ft in pairs(servers) do
  vim.api.nvim_create_autocmd('FileType', {
    pattern = ft,
    callback = function()
      local ok, cfg = pcall(require, 'lsp.' .. server)
      cfg = ok and cfg or {}
      cfg.on_attach = cfg.on_attach or require 'utils.lsp'.on_attach
      cfg.capabilities = cfg.capabilities or require 'utils.lsp'.capabilities
      cfg.name = server
      cfg.root_markers = cfg.root_markers or { '.git' }
      cfg.root_dir = require 'utils.plugins'.root_pattern(cfg.root_markers)(vim.api.nvim_buf_get_name(0))
          or vim.fn.getcwd()

      vim.lsp.start(cfg)
    end
  })
end
