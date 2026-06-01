for server, v in pairs(NeoVim.lsp.servers) do
  NeoVim.lsp.config(server)
end
