local M = {}

M.keys = {
  {
    "<leader>ff",
    function()
      require("fzf-lua").files({
        fd_opts = "-I -t f -E .git -H",
      })
    end,
    desc = "Find Files (Root dir)",
    mode = { "n", "v" },
  },
  {
    "<leader>fh",
    function()
      vim.cmd [[e ~/.zsh_history]]
    end,
    desc = "Terminal history",
    mode = { "n", "v" },
  },
  {
    "<leader>fs",
    function()
      vim.cmd [[e ~/.zshrc]]
    end,
    desc = "Zsh config",
    mode = { "n", "v" },
  },
  { "<leader>fF", false },
}

return M
