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
  {
    "<leader><leader>",
    function()
      local file_dir = vim.fn.expand("%:p:h") -- directory of current buffer
      local git_root = vim.fn.systemlist("git -C " .. vim.fn.fnameescape(file_dir) .. " rev-parse --show-toplevel")[1]

      if git_root == nil or git_root == "" or git_root:match("^fatal") then
        git_root = vim.fn.getcwd()
      end

      require("fzf-lua").files({
        cwd = git_root,
        fd_opts = "-I -t f -E .git -H",
      })
    end,
    desc = "Find Files (git-files or cwd)",
  },
  { "<leader>fF", false },
}

return M
