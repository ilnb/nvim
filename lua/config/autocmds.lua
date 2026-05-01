-- asm files indentation
-- vim.api.nvim_create_autocmd('BufWritePre', {
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

-- diagnostics config
vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  callback = function()
    vim.diagnostic.config {
      float = { border = 'rounded' },
      update_in_insert = false,
      virtual_text = {
        current_line = nil,
        spacing = 4,
        source = 'if_many',
        prefix = '●',
      },
      severity_sort = true,
      signs = {
        text = {
          ERROR = ' ',
          WARN  = ' ',
          INFO  = ' ',
          HINT  = ' ',
          error = ' ',
          warn  = ' ',
          info  = ' ',
          hint  = ' ',
          Error = ' ',
          Warn  = ' ',
          Info  = ' ',
          Hint  = ' ',
        },
      },
    }

    local hl = vim.api.nvim_set_hl
    local uc = { 'DiagnosticVirtualTextWarn', 'DiagnosticVirtualTextInfo', 'DiagnosticVirtualTextHint' }
    local ul = { 'DiagnosticVirtualTextError' }

    for _, name in ipairs(uc) do
      hl(0, name, { undercurl = true })
    end

    for _, name in ipairs(ul) do
      hl(0, name, { underline = true })
    end
  end
})
