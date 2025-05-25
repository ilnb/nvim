local M = {}

M.opts = function(_, opts)
  vim.list_extend(opts.ensure_installed, { "zig", "css", "html", "javascript" })

  opts.highlight = opts.highlight or {}
  opts.highlight.disable = function(_, buf)
    local max_filesize = 100 * 1024
    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
    return ok and stats and stats.size > max_filesize
  end

  opts.textobjects = opts.textobjects or {}
  opts.textobjects.select = vim.tbl_deep_extend("force", opts.textobjects.select or {}, {
    enable = true,
    lookahead = true,
    keymaps = {
      ["af"] = { query = "@function.outer", desc = "outer function" },
      ["if"] = { query = "@function.inner", desc = "inner function" },
      ["ac"] = { query = "@class.outer", desc = "outer class" },
      ["ic"] = { query = "@class.inner", desc = "inner class" },
    },
  })
  return opts
end

return M
