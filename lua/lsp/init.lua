for server, ft in pairs(NeoVim.lsp.servers) do
  vim.api.nvim_create_autocmd('FileType', {
    pattern = ft,
    callback = function()
      NeoVim.lsp.start(server)
    end
  })
end
