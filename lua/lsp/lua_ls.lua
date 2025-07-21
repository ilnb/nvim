return {
  capabilities = require 'utils.lsp'.capabilities,
  on_attach = require 'utils.lsp'.on_attach,
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
