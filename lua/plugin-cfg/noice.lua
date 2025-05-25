local M = {}

---@diagnostic disable: missing-fields
M.keys = function(_, keys)
  return keys
end

---@param opts NoiceConfig
M.opts = function(_, opts)
  opts.views = {
    hover = {
      scrollbar = false
    }
  }
  opts.cmdline = {
    view = "cmdline" -- for default cmdline
  }
  opts.presets = {
    lsp_doc_border = true,
    bottom_search = true, -- false to sync it to cmdline
    long_message_to_split = true,
  }
  return opts
end

M.config = function(_, opts)
  if vim.o.filetype == "lazy" then
    vim.cmd([[messages clear]])
  end
  require("noice").setup(opts)
end

return M
