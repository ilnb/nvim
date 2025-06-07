local M = {}

M.opts = function(_, opts)
  local langs = { "asm", "css", "gitignore", "zig" }
  opts.ensure_installed = vim.tbl_deep_extend("force", opts.ensure_installed, langs)
  opts.auto_install = true
  opts.indent.enable = true
  return opts
end

return M
