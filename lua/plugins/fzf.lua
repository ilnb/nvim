return {
  "ibhagwan/fzf-lua",
  keys = {
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
    {
      "<leader>F",
      function()
        vim.cmd [[FzfLua]]
      end,
      desc = "FzfLua",
      mode = { "n", "v" },
    },
    {
      "<leader>sB",
      function()
        require('fzf-lua').blines()
      end,
      desc = "Buffer lines",
      mode = { "n", "v" },
    },
    {
      "<leader>sb",
      function()
        require('fzf-lua').lgrep_curbuf()
      end,
      desc = "Buffer grep",
      mode = { "n", "v" },
    },
  }
}
