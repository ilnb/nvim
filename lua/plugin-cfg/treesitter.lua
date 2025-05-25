local M = {}

M.opts = function(_, opts)
  opts.ensure_installed = vim.tbl_deep_extend("force", opts.ensure_installed, { "zig", "css", "gitignore" })
  opts.auto_install = true
  return opts
end

return M
