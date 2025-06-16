return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    -- "nvim-treesitter/playground",
    "nvim-treesitter/nvim-treesitter-textobjects",
    "echasnovski/mini.ai",
  },
  opts = {
    ensure_installed = { "asm", "css", "gitignore", "zig" },
    auto_install = true,
    indent = { enable = true },
  }
}
