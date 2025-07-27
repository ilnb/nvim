return {
  'mikavilpas/yazi.nvim',
  event = 'VeryLazy',
  dependencies = { 'folke/snacks.nvim' },

  keys = {
    {
      '<leader>-',
      mode = { 'n', 'v' },
      ':Yazi<cr>',
      desc = 'Open yazi at the current file',
    },
    {
      '<leader>cw',
      mode = { 'n', 'v' },
      ':Yazi cwd<cr>',
      desc = 'Open the file manager in nvim\'s working directory',
    },
    {
      '<c-up>',
      ':Yazi toggle<cr>',
      desc = 'Resume the last yazi session',
    },
  },

  init = function()
    -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
    -- vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 0
  end,

  ---@module 'yazi.types'
  ---@type YaziConfig
  opts = {
    keymaps = {
      show_help = '<f1>',
    },
    multiple_open = true,
    open_for_directories = true,
  }
}
