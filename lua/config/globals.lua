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
    -- pyright = { ft = { 'python' } },
    lua_ls        = { ft = { 'lua', 'nvim-pack' } },
    nimlangserver = { ft = { 'nim' } },
    ols           = { ft = { 'odin' } },
    ['serve-d']   = { ft = { 'd' } },
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
  start = function(server)
    local t = NeoVim.lsp.servers[server]
    local ft = vim.bo[0].filetype
    if not vim.tbl_contains(t.ft, ft) then
      vim.notify('Cannot attach server ' .. server .. ' to ft ' .. ft, vim.log.levels.INFO)
      return
    end
    if not t.opts then
      local ok, cfg = pcall(require, 'lsp.' .. server)
      cfg = ok and cfg or {}
      cfg.on_attach = cfg.on_attach or require 'utils.lsp'.on_attach
      cfg.capabilities = cfg.capabilities or require 'utils.lsp'.capabilities
      cfg.name = server
      if not cfg.root_dir then
        cfg.root_markers = cfg.root_markers or { '.git' }
      end
      cfg.root_dir = cfg.root_dir or vim.fs.root(0, cfg.root_markers) or vim.uv.cwd()
      t.opts = cfg
    end
    vim.lsp.start(t.opts)
  end
}
