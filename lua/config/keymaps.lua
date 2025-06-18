local m = vim.keymap.set

m('n', '<leader>o', function()
    vim.cmd [[call append(line('.'), repeat([''], v:count1))]]
  end,
  { silent = true, desc = 'Newline below' }
)

m('n', '<leader>O', function()
    vim.cmd [[call append(line('.')-1, repeat([''], v:count1))]]
  end,
  { silent = true, desc = 'Newline above' }
)
