return {
  {
    'neovim/nvim-lspconfig',
    ft = { 'c', 'cpp', 'cs', 'python', 'asm', 'lua' },
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
      -- local ok_mason, mlsp = pcall(require, 'mason-lspconfig')
      local all_servers = {
        'asm_lsp',
        'lua_ls',
        'clangd',
        -- 'pyright',
        'basedpyright',
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
        local opt = {}
        if vim.tbl_contains(servers, lang) then
          opt = require('lsp.' .. lang)
        else
          opt.capabilities = require 'utils.lsp'.capabilities
          opt.on_attach = require 'utils.lsp'.on_attach
        end
        require 'lspconfig'[lang].setup(opt)
      end
    end
  },

  {
    'SmiteshP/nvim-navic',
    init = function()
      vim.g.navic_silence = true
    end,

    opts = {
      separator = ' ',
      highlight = true,
      depth_limit = 5,
      icons = {
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
        Text          = ' ',
        TypeParameter = ' ',
        Unit          = ' ',
        Value         = ' ',
        Variable      = '󰀫 ',
      },
      lazy_update_context = true,
    }
  },

  {
    'folke/lazydev.nvim',
    ft = 'lua',
    cmd = 'LazyDev',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        { path = 'snacks.nvim',        words = { 'Snacks', 'snacks.nvim' } },
      },
    },
  }
}
