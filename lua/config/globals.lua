_G.NeoVim = {}

NeoVim.icons = {
  kind = {
    Array         = ' ',
    Boolean       = '󰨙 ',
    Class         = ' ',
    Color         = ' ',
    Control       = ' ',
    Collapsed     = ' ',
    Constant      = '󰏿 ',
    Constructor   = ' ',
    Enum          = ' ',
    EnumMember    = ' ',
    Event         = ' ',
    Field         = ' ',
    File          = ' ',
    Folder        = ' ',
    Function      = '󰊕 ',
    Interface     = ' ',
    Key           = ' ',
    Keyword       = ' ',
    Method        = '󰊕 ',
    Module        = ' ',
    Namespace     = '󰦮 ',
    Null          = ' ',
    Number        = '󰎠 ',
    Object        = ' ',
    Operator      = ' ',
    Package       = ' ',
    Property      = ' ',
    Reference     = ' ',
    Snippet       = '󱄽 ',
    String        = ' ',
    Struct        = '󰆼 ',
    Supermaven    = ' ',
    Text          = ' ', -- 󰉿
    TypeParameter = ' ',
    Unit          = ' ',
    Value         = ' ',
    Variable      = '󰀫 ',
  },

  diagnostics = {
    ERROR = ' ',
    WARN  = ' ',
    INFO  = ' ',
    HINT  = ' ',
    error = ' ',
    warn  = ' ',
    info  = ' ',
    hint  = ' ',
    Error = ' ',
    Warn  = ' ',
    Info  = ' ',
    Hint  = ' ',
  },

  git = {
    -- added    = ' ',
    -- modified = ' ',
    -- removed  = ' ',
    added = '+',
    modified = '~',
    removed = '-',
  },
}

NeoVim.snippets = {
  langs = {
    'c',
    'cpp',
    'zig',
  },
  lang_done = {},
}

NeoVim.lsp = {
  servers = {
    asm_lsp       = { ft = { 'asm' } },
    basedpyright  = { ft = { 'python' } },
    -- ccls         = { ft = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' } },
    clangd        = { ft = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' } },
    gopls         = { ft = { 'go' } },
    -- pyright       = { ft = { 'python' } },
    lua_ls        = { ft = { 'lua', 'nvim-pack' } },
    nimlangserver = { ft = { 'nim' } },
    ols           = { ft = { 'odin' } },
    serve_d       = { ft = { 'd' } },
    ts_ls         = { ft = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' } },
    qmlls6        = { ft = { 'qml', 'qmljs' } },
    zls           = { ft = { 'zig' } },
  },

  gen_ft = function()
    local ret = {}
    for _, v in pairs(NeoVim.lsp.servers) do
      for _, x in ipairs(v.ft) do
        table.insert(ret, x)
      end
    end
    NeoVim.lsp.ft = ret
    return ret
  end,

  ---@param server string
  config = function(server)
    local t = NeoVim.lsp.servers[server]
    if not t.opts then
      local ok, cfg = pcall(require, 'lsp.' .. server)
      cfg = ok and cfg or {} --[[@as vim.lsp.Config]]
      local f = cfg.on_attach or function() end --[[@as function]]
      cfg.on_attach = function(client, buf)
        f(client, buf); require 'utils.lsp'.on_attach(client, buf)
      end
      cfg.capabilities = vim.tbl_deep_extend('force', require 'utils.lsp'.capabilities, cfg.capabilities or {})
      cfg.name = server
      if not cfg.root_dir then
        if not vim.tbl_contains(cfg.root_markers or {}, '.git') then
          cfg.root_markers = vim.list_extend(cfg.root_markers or {}, { '.git' })
        end
      end
      cfg.root_dir = cfg.root_dir or vim.fs.root(0, cfg.root_markers) or vim.uv.cwd()
      t.opts = cfg
      t.opts.filetypes = t.ft
      vim.lsp.config(server, t.opts)
    end
    if not t.enabled then
      t.enabled = true
      vim.lsp.enable(server)
    end
  end,

  ---@param server string
  start = function(server)
    local lsp = NeoVim.lsp
    lsp.config(server)
    vim.lsp.start(lsp.servers[server].opts)
  end
}
