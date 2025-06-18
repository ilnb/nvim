return {
  'nvim-neo-tree/neo-tree.nvim',
  dependencies = {
    { 'nvim-lua/plenary.nvim', },
    -- {'nvim-tree/nvim-web-devicons',},
    { 'MunifTanjim/nui.nvim', },
    -- {'3rd/image.nvim', opts = {}}, -- Optional image support in preview window
  },

  ---@module 'neo-tree'
  ---@type neotree.Config
  opts = {
    filesystem = {
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
      },
    },
  }
}
