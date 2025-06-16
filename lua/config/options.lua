-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.fillchars = {
  foldopen = "",
  foldclose = "",
  -- fold = "·",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}

-- vim.opt.foldtext = "v:lua.require'config.utils'.custom_foldtext()"
