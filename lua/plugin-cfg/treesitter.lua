local M = {}

M.config = function()
  require('nvim-treesitter.configs').setup({
    ensure_installed = { "c", "cpp", "lua", "bash", "python", "zig", "css", "html", "javascript" },
    sync_install = false, -- applies to ensure_installed
    ignore_install = {},
    highlight = {
      enable = true,
      disable = function(lang, buf)     -- big files cook treesitter
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end
      end,
    },
    modules = {},
    auto_install = true, -- missing parsers are installed using TS CLI
    textobjects = {
      select =
      {
        enable = true,
        lookahead = true,
        keymaps = {
          ["af"] = { query = "@function.outer", desc = "function outer" },
          ["if"] = { query = "@function.inner", desc = "function inner" },
          ["ac"] = { query = "@class.outer", desc = "class outer" },
          ["ic"] = { query = "@class.inner", desc = "class inner" },
        },
      }
    }
  })
end

return M
