for server, v in pairs(NeoVim.lsp.servers) do
  vim.api.nvim_create_autocmd('FileType', {
    pattern = v.ft,
    callback = function()
      NeoVim.lsp.start(server)
    end
  })
end
