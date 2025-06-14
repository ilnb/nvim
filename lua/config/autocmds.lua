-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- asm files indentation
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   pattern = { '*.asm', '*.s', '*.S' },
--   callback = function()
--     local pos = vim.api.nvim_win_get_cursor(0)
--     vim.cmd [[norm! gg=G]]
--     vim.api.nvim_win_set_cursor(0, pos)
--   end
-- })

-- comments in asm
vim.api.nvim_create_autocmd("FileType", {
  pattern = "asm",
  callback = function()
    vim.opt_local.commentstring = "# %s"
  end,
})
