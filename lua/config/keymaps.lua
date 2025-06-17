-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local m = vim.keymap.set
m("n", "<leader>o", function()
    vim.cmd [[call append(line("."), repeat([''], v:count1))]]
  end,
  { silent = true, desc = "Newline below" }
)

m("n", "<leader>O", function()
    vim.cmd [[call append(line(".")-1, repeat([''], v:count1))]]
  end,
  { silent = true, desc = "Newline above" }
)
