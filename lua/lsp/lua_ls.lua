return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  settings = {
    Lua = {
      telemetry = { enable = false },
      diagnostics = {
        globals = {
          'vim',
          'require',
        },
      },
      runtime = {
        version = 'LuaJIT',
        path = vim.split(package.path, ';'),
      },
      workspace = {
        checkThirdParty = false,
      },
      completion = {
        callSnippet = 'Replace',
      },
      doc = {
        privateName = { '^_' },
      },
      hint = {
        enable = true,
        setType = false,
        paramType = true,
        paramName = 'Disable',
        semicolon = 'Disable',
        arrayIndex = 'Disable',
      },
    },
  },
}
