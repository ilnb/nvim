-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- asm files indentation
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { '*.asm', '*.s', '*.S' },
  callback = function()
    vim.cmd [[norm! gg=G]]
  end
})
