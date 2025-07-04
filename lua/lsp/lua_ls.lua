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
        -- using lazydev instead
        --[[
        library = {
          vim.env.VIMRUNTIME,
          '${3rd}/luv/library',
          vim.fn.stdpath 'config',
          vim.fn.stdpath 'data' .. '/lazy/snacks.nvim',
          vim.fn.stdpath 'data' .. '/lazy/flash.nvim',
          vim.fn.stdpath 'data' .. '/lazy/lazy.nvim',
          vim.fn.stdpath 'data' .. '/lazy/kanagawa.nvim',
          vim.fn.stdpath 'data' .. '/lazy/kanso.nvim',
          vim.fn.stdpath 'data' .. '/lazy/catppuccin',
          vim.fn.stdpath 'data' .. '/lazy/blink.cmp',
        },
        --]]
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
