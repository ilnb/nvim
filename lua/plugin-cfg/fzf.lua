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
      local buf_path = vim.api.nvim_buf_get_name(0)
      local file_dir = buf_path ~= "" and vim.fn.fnamemodify(buf_path, ":h") or nil

      local base_dir = file_dir or vim.fn.getcwd()
      local git_cmd = "git -C '" .. base_dir .. "' rev-parse --show-toplevel"

      local git_root = vim.fn.systemlist(git_cmd)[1]
      if not git_root or git_root == "" or git_root:match("^fatal") then
        git_root = base_dir
      end

      require("fzf-lua").files({
        cwd = vim.fn.fnamemodify(git_root, ":p"),
        fd_opts = "-I -t f -E .git -H",
      })
    end,
    desc = "Find Files (git-files or cwd)",
  },
  { "<leader>fF", false },
}

return M
