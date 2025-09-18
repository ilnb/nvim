_G.servers = {
  asm_lsp      = { ft = { 'asm' }, done = false },
  basedpyright = { ft = { 'python' }, done = false },
  clangd       = { ft = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' }, done = false },
  gopls        = { ft = { 'go' }, done = false },
  lua_ls       = { ft = { 'lua' }, done = false },
  zls          = { ft = { 'zig' }, done = false },
}

for server, tbl in pairs(servers) do
  vim.api.nvim_create_autocmd('FileType', {
    pattern = tbl.ft,
    callback = function()
      local ok, opts = pcall(require, 'lsp.' .. server)
      opts = ok and opts or {}
      opts.on_attach = opts.on_attach or require 'utils.lsp'.on_attach
      opts.capabilities = opts.capabilities or require 'utils.lsp'.capabilities
      opts.filetypes = tbl.ft

      if not servers[server].done then
        vim.lsp.start(vim.tbl_extend('force', opts, { name = server }))
        servers[server].done = true
      else
        for _, client in pairs(vim.lsp.get_clients()) do
          if client.name == server then
            vim.lsp.buf_attach_client(0, client.id)
          end
        end
      end
    end
  })
end
