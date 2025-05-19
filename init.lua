-- bootstrap lazy.nvim, LazyVim and your plugins
vim.o.title = true
vim.o.titlestring = "nvim %{expand('%:t')}"
require("config.plugins")
