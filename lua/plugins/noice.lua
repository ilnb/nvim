return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  keys = {
    { '<leader>snh', false },
    { '<leader>snl', false },
  },

  ---@diagnostic disable: missing-fields
  ---@type NoiceConfig
  opts = {
    views = {
      hover = {
        scrollbar = false,
      },
    },
    cmdline = {
      view = 'cmdline', -- for default cmdline
    },
    presets = {
      lsp_doc_border = true,
      bottom_search = true,
      long_message_to_split = true,
    },
    lsp = {
      signature = {
        enabled = false,
      },
    },
  },

  config = function(_, opts)
    if vim.o.filetype == 'lazy' then
      vim.cmd [[messages clear]]
    end
    require 'noice'.setup(opts)
  end
}
