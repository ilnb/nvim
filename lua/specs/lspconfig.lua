return {
  {
    'SmiteshP/nvim-navic',
    ft = NeoVim.lsp.ft,
    modname = 'nvim-navic',

    opts = {
      separator = ' ',
      highlight = true,
      depth_limit = 5,
      icons = NeoVim.icons.kind,
      lazy_update_context = true,
    },
  },

  {
    'folke/lazydev.nvim',
    ft = 'lua',
    cmd = { 'LazyDev' },
    deps = {
      { 'DrKJeff16/wezterm-types', lazy = true },
    },
    modname = 'lazydev',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        { path = 'snacks.nvim',        words = { 'Snacks', 'snacks.nvim' } },
        { path = 'fzf-lua',            words = { 'FzfLua', 'fzf-lua' } },
        { path = 'wezterm-types',      words = { 'wezterm' } },
        { path = 'tokyonight.nvim',    words = { 'tokyonight.nvim' } },
      },
    },
  },

}
