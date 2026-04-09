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
    Text          = '󰉿 ', -- 
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
    asm_lsp       = { 'asm' },
    basedpyright  = { 'python' },
    -- ccls         = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
    clangd        = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
    gopls         = { 'go' },
    -- pyright = { 'python' },
    lua_ls        = { 'lua', 'nvim-pack' },
    nimlangserver = { 'nim' },
    ['serve-d']   = { 'd' },
    qmlls6        = { 'qml', 'qmljs' },
    zls           = { 'zig' },
  },
  ft = {
    'asm',
    'python',
    'c', 'cpp', 'objc', 'objcpp', 'cuda',
    'go',
    'lua',
    'nim',
    'd',
    'qml', 'qmljs',
    'zig',
  }
}
