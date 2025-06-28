return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = nil,

  opts = {
    inlay_hints = {
      enabled = true,
      exclude = {}
    },
    capabilities = {
      workspace = {
        fileOperations = {
          didRename = true,
          willRename = true,
        },
      },
    },
    format = {
      formatting_options = nil,
      timeout_ms = nil
    },
  },

  config = function(_, opts)
    vim.diagnostic.config ---@type vim.diagnostic.Opts
    {
      underline = true,
      update_in_insert = false,
      virtual_text = {
        current_line = true,
        spacing = 4,
        source = 'if_many',
        prefix = '●',
      },
      severity_sort = true,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = ' ',
          [vim.diagnostic.severity.WARN] = ' ',
          [vim.diagnostic.severity.HINT] = ' ',
          [vim.diagnostic.severity.INFO] = ' ',
        },
      },
    }
    -- local ok_mason, mlsp = pcall(require, 'mason-lspconfig')
    local all_servers = {
      'asm_lsp',
      'lua_ls',
      'clangd',
      'pyright'
    }
    -- if ok_mason then
    --   all_servers = mlsp.get_installed_servers()
    -- end

    local servers = {}

    local langdir = vim.fn.stdpath 'config' .. '/lua/lsp'
    local langs = vim.fn.globpath(langdir, '*.lua', false, true)
    for _, v in ipairs(langs) do
      local s = vim.fn.fnamemodify(v, ':t:r')
      table.insert(servers, s)
    end

    for _, lang in ipairs(all_servers) do
      local opt
      local lsp = require 'lspconfig'
      if vim.tbl_contains(servers, lang) then
        opt = require('lsp.' .. lang)
      else
        opt = {}
        opt.capabilities = require 'utils.lsp'.capabilities
        opt.on_attach = require 'utils.lsp'.on_attach
      end
      lsp[lang].setup(opt)
    end
  end
}
