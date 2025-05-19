local M = {}

-- If you use `open_for_directories=true`, this is recommended
M.init = function()
  -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
  -- vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 0
end

M.keys = {
  {
    "<leader>-",
    mode = { "n", "v" },
    "<cmd>Yazi<cr>",
    desc = "Open yazi at the current file",
  },
  {
    "<leader>cw",
    mode = { "n", "v" },
    "<cmd>Yazi cwd<cr>",
    desc = "Open the file manager in nvim's working directory",
  },
  {
    "<c-up>",
    "<cmd>Yazi toggle<cr>",
    desc = "Resume the last yazi session",
  },
}

---@module 'yazi.types'
---@type YaziConfig
M.opts = {
  keymaps = {
    show_help = "<f1>",
  },
  multiple_open = true,
  open_for_directories = true,
}

return M
