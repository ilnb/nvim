return {
  {
    'neovim/nvim-lspconfig',
    ft = { 'c', 'cpp', 'cs', 'python', 'asm', 'lua', 'go', 'zig' },
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

    config = function()
      local all_servers = {
        'asm_lsp',
        'basedpyright',
        'clangd',
        'gopls',
        'lua_ls',
        -- 'pyright',
        'zls',
      }

      for _, lang in ipairs(all_servers) do
        local ok, opts = pcall(require, 'lsp.' .. lang)
        opts = ok and opts or {}
        opts.on_attach = opts.on_attach or require 'utils.lsp'.on_attach
        opts.capabilities = opts.capabilities or require 'utils.lsp'.capabilities
        require 'lspconfig'[lang].setup(opts)
      end
    end
  },

  {
    'SmiteshP/nvim-navic',

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
