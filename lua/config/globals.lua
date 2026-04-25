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
    ['serve-d']   = { ft = { 'd' } },
    qmlls6        = { ft = { 'qml', 'qmljs' } },
    zls           = { ft = { 'zig' } },
  },

  ft = {
    'asm',
    'python',
    'c', 'cpp', 'objc', 'objcpp', 'cuda',
    'go',
    'lua', 'nvim-pack',
    'nim',
    'd',
    'qml', 'qmljs',
    'zig',
  },

  ---@param server string
  start = function(server)
    local t = NeoVim.lsp.servers[server]
    if not t.opts then
      local ok, cfg = pcall(require, 'lsp.' .. server)
      cfg = ok and cfg or {}
      cfg.on_attach = cfg.on_attach or require 'utils.lsp'.on_attach
      cfg.capabilities = cfg.capabilities or require 'utils.lsp'.capabilities
      cfg.name = server
      cfg.root_markers = cfg.root_markers or { '.git' }
      cfg.root_dir = require 'utils.plugins'.root_pattern(cfg.root_markers)(vim.api.nvim_buf_get_name(0))
          or vim.fn.getcwd()
      t.opts = cfg
    end
    vim.lsp.start(t.opts)
  end
}
