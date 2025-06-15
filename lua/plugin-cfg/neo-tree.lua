local M = {}

---@module 'neo-tree'
---@type neotree.Config
M.opts = {
  filesystem = {
    filtered_items = {
      visible = true,
      hide_dotfiles = false,
    },
  },
}

return M
