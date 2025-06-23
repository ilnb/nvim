local map = vim.keymap.set

map('n', '<leader>o', function()
    vim.cmd [[call append(line('.'), repeat([''], v:count1))]]
  end,
  { silent = true, desc = 'Newline below' }
)

map('n', '<leader>O', function()
    vim.cmd [[call append(line('.')-1, repeat([''], v:count1))]]
  end,
  { silent = true, desc = 'Newline above' }
)

-- typo fixes
vim.cmd [[
    cnoreabbrev W! w!
    cnoreabbrev W1 w!
    cnoreabbrev w1 w!
    cnoreabbrev Q! q!
    cnoreabbrev Q1 q!
    cnoreabbrev q1 q!
    cnoreabbrev Qa! qa!
    cnoreabbrev Qall! qall!
    cnoreabbrev Wa wa
    cnoreabbrev Wq wq
    cnoreabbrev wQ wq
    cnoreabbrev WQ wq
    cnoreabbrev W w
    cnoreabbrev Q q
    cnoreabbrev Qa qa
    cnoreabbrev Qall qall
]]
