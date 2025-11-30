local function augroup(name)
  return vim.api.nvim_create_augroup('root_' .. name, { clear = true })
end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  group = augroup 'checktime',
  callback = function()
    if vim.o.buftype ~= 'nofile' then
      vim.cmd('checktime')
    end
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  group = augroup 'highlight_yank',
  callback = function()
    (vim.hl or vim.highlight).on_yank()
  end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ 'VimResized' }, {
  group = augroup 'resize_splits',
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd 'tabdo wincmd ='
    vim.cmd('tabnext ' .. current_tab)
  end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd('BufReadPost', {
  group = augroup 'last_loc',
  callback = function(event)
    local exclude = { 'gitcommit' }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end
    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd('FileType', {
  group = augroup 'close_with_q',
  pattern = {
    'PlenaryTestPopup',
    'checkhealth',
    'dbout',
    'gitsigns-blame',
    'grug-far',
    'help',
    'lspinfo',
    'neotest-output',
    'neotest-output-panel',
    'neotest-summary',
    'notify',
    'qf',
    'spectre_panel',
    'startuptime',
    'tsplayground',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set('n', 'q', function()
        vim.cmd('close')
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = 'Quit buffer',
      })
    end)
  end,
})

-- make it easier to close man-files when opened inline
vim.api.nvim_create_autocmd('FileType', {
  group = augroup 'man_unlisted',
  pattern = { 'man' },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
  end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd('FileType', {
  group = augroup 'wrap_spell',
  pattern = { 'text', 'plaintex', 'typst', 'gitcommit', 'markdown' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd({ 'FileType' }, {
  group = augroup 'json_conceal',
  pattern = { 'json', 'jsonc', 'json5' },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  group = augroup 'auto_create_dir',
  callback = function(event)
    if event.match:match '^%w%w+:[\\/][\\/]' then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
})

-- enable snacks indent guides for new files
vim.api.nvim_create_autocmd('BufNewFile', {
  callback = function()
    require 'snacks.indent'.enable()
  end
})

-- # comment symbol for asm
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'asm',
  callback = function()
    vim.bo.commentstring = '# %s'
  end
})

-- diagnostics config
vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  callback = function()
    vim.diagnostic.config
    {
      float = { border = 'rounded' },
      underline = { severity = 'ERROR' },
      update_in_insert = false,
      virtual_text = {
        current_line = false,
        spacing = 4,
        source = 'if_many',
        prefix = '●',
      },
      severity_sort = true,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = ' ',
          [vim.diagnostic.severity.WARN] = ' ',
          [vim.diagnostic.severity.HINT] = ' ',
          [vim.diagnostic.severity.INFO] = ' ',
        },
      },
    }
  end
})

-- open embedded markdown files in lsp hover
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'noice',
  callback = function()
    local buf = vim.api.nvim_get_current_buf()
    local bt = vim.api.nvim_get_option_value('buftype', { buf = buf })
    if bt ~= 'nofile' then return end

    vim.keymap.set('n', '<leader><cr>', function()
      local line = vim.api.nvim_get_current_line()
      local col = vim.api.nvim_win_get_cursor(0)[2] + 1

      -- expand left to find '['
      local start_idx = col
      while start_idx > 1 and line:sub(start_idx, start_idx) ~= '[' do
        start_idx = start_idx - 1
      end

      -- expand right to find ']'
      local end_idx = col
      while end_idx <= #line and line:sub(end_idx, end_idx) ~= ']' do
        end_idx = end_idx + 1
      end

      -- extract target in parentheses immediately after ']'
      local target = line:sub(end_idx + 2, line:find(')', end_idx + 2) - 1)

      if target and target:match '^file:' then
        local path, lnum = target:match('^file:(.+)#L(%d+)$')
        if not path then path = target:sub(6) end

        local buf_name = vim.api.nvim_buf_get_name(buf)

        -- already have the file open
        if vim.fn.fnamemodify(buf_name, ':p') == path then
          if lnum then vim.cmd('norm!' .. lnum .. 'G') end
          return
        end

        -- have it open in another window
        local ex = vim.fn.bufnr(path)
        if ex ~= -1 then
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_get_buf(win) == ex then
              vim.api.nvim_set_current_win(win)
              if lnum then vim.cmd('norm!' .. lnum .. 'G') end
              return
            end
          end
        end

        -- new file to open
        vim.cmd 'quit'
        vim.cmd('split ' .. path)
        if lnum then vim.cmd('norm!' .. lnum .. 'G') end
      end
    end, { buffer = buf, desc = 'Open the linked file' })
  end,
})
