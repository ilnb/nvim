return {
  "nvim-neo-tree/neo-tree.nvim",
  lazy = true,
  config = function()
    require("neo-tree").setup({
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
        },
      },
    })
  end,
}
