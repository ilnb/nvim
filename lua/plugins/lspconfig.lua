return {
  {
    'SmiteshP/nvim-navic',

    opts = {
      separator = ' ',
      highlight = true,
      depth_limit = 5,
      icons = NeoVim.icons.kind,
      lazy_update_context = true,
    }
  },

  {
    'folke/lazydev.nvim',
    ft = 'lua',
    cmd = { 'LazyDev' },
    dependencies = {
      { 'DrKJeff16/wezterm-types' },
    },
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        { path = 'snacks.nvim',        words = { 'Snacks', 'snacks.nvim' } },
        { path = 'wezterm-types',      words = { 'wezterm' } },
        { path = 'tokyonight.nvim',    words = { 'tokyonight.nvim' } },
        { path = 'wisteria.nvim',      words = { 'Wisteria', 'wisteria.nvim' } },
      },
    },
  },

}
