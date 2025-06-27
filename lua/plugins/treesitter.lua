return {
  'nvim-treesitter/nvim-treesitter',
  event = function() return { 'BufReadPost', 'BufNewFile' } end,
  dependencies = {
    -- 'nvim-treesitter/playground',
    {
      'nvim-treesitter/nvim-treesitter-textobjects',
      event = function() return { 'BufReadPost', 'BufNewFile' } end,
    },
    'echasnovski/mini.ai',
  },

  opts = {
    ensure_installed = { 'asm', 'css', 'gitignore', 'zig' },
    auto_install = true,
    indent = { enable = true },
    textobjects = {
      swap = {
        enable = true,
        swap_next = { ['<A-l>'] = '@parameter.inner' },
        swap_previous = { ['<A-h>'] = '@parameter.inner' }
      }
    },
    highlight = { enable = true }
  }
}
