local servers = {
  asm_lsp      = { 'asm' },
  basedpyright = { 'python' },
  clangd       = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
  gopls        = { 'go' },
  -- pyright = { 'python' },
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

vim.api.nvim_create_user_command('LspStop', function(opts)
  local args = {}
  if opts.args ~= "" then
    for name in string.gmatch(opts.args, "%S+") do
      table.insert(args, name)
    end
  end

  local clients = vim.lsp.get_clients { bufnr = 0 }
  if #clients == 0 then return end

  for _, client in ipairs(clients) do
    if args == {} or vim.tbl_contains(args, client.name) then
      client:stop(true)
    end
  end
end, {
  nargs = '*',
  complete = function()
    local ret = {}
    for server, _ in pairs(servers) do
      ret[#ret + 1] = server
    end
    return ret
  end
})

vim.api.nvim_create_user_command('LspStart', function(opts)
  local args = {}
  if opts.args ~= "" then
    for name in string.gmatch(opts.args, "%S+") do
      table.insert(args, name)
    end
  end
  local ft = vim.bo.filetype

  if #args == 0 then
    for server, fts in pairs(servers) do
      if vim.tbl_contains(fts, ft) then
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
    end
  else
    for _, server in ipairs(args) do
      local fts = servers[server]
      if fts and vim.tbl_contains(fts, ft) then
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
    end
  end
end, {
  nargs = '*',
  complete = function()
    local ret = {}
    for server, _ in pairs(servers) do
      ret[#ret + 1] = server
    end
    return ret
  end
})

vim.api.nvim_create_user_command('LspRestart', function()
  local ft = vim.bo.filetype
  local clients = vim.lsp.get_clients { bufnr = 0 }

  for _, client in ipairs(clients) do
    client:stop(true)
  end

  for server, fts in pairs(servers) do
    if vim.tbl_contains(fts, ft) then
      local ok, cfg = pcall(require, 'lsp.' .. server)
      cfg = ok and cfg or {}
      cfg.on_attach = cfg.on_attach or require 'utils.lsp'.on_attach
      cfg.capabilities = cfg.capabilities or require 'utils.lsp'.capabilities
      cfg.name = server
      cfg.root_markers = cfg.root_markers or { '.git' }
      cfg.root_dir = require('utils.plugins').root_pattern(cfg.root_markers)(vim.api.nvim_buf_get_name(0))
          or vim.fn.getcwd()

      vim.lsp.start(cfg)
    end
  end
end, { nargs = 0 })
