local M = {}

---@alias lsp.Client.filter {id?: number, bufnr?: number, name?: string, method?: string, filter?:fun(client: lsp.Client):boolean}
---@param opts? lsp.Client.filter
function M.get_clients(opts)
  local ret = {} ---@type vim.lsp.Client[]
  if vim.lsp.get_clients then
    ret = vim.lsp.get_clients(opts)
  else
    ---@diagnostic disable-next-line: deprecated
    ret = vim.lsp.get_active_clients(opts)
    if opts and opts.method then
      ---@param client vim.lsp.Client
      ret = vim.tbl_filter(function(client)
        return client:supports_method(opts.method, opts.bufnr)
      end, ret)
    end
  end
  return opts and opts.filter and vim.tbl_filter(opts.filter, ret) or ret
end

---@param client vim.lsp.Client
---@param buffer integer
M.on_attach = function(client, buffer)
  local map = function(...)
    local args = { ... }
    if #args == 3 then
      vim.keymap.set('n', args[1], args[2], { buffer = buffer, desc = args[3] })
    elseif #args == 4 then
      vim.keymap.set(args[1], args[2], args[3], { buffer = buffer, desc = args[4] })
    else
      vim.notify('Invalid arguments to map(). Expected (key, fn, desc) or (mode, key, fn, desc)', vim.log.levels.ERROR)
    end
  end
  local del = function(mode, key)
    pcall(vim.keymap.del, mode, key)
  end

  map('gd', function() require 'fzf-lua'.lsp_definitions() end, 'Goto Definition')
  map('gD', function() require 'fzf-lua'.lsp_declarations() end, 'Goto Declaration')
  map('K', function() vim.lsp.buf.hover() end, 'Hover')
  map('<leader>la', function() vim.lsp.buf.code_action() end, 'Code Action')
  map('<leader>lr', function() vim.lsp.buf.rename() end, 'Rename')
  map('<leader>lf', function() vim.lsp.buf.format() end, 'Lsp Format')
  map('<leader>ld', function() vim.diagnostic.open_float() end, 'Line Diagnostics')
  map('<leader>ll', function() Snacks.picker.lsp_config() end, 'Lsp Info')
  map('<leader>sd', function() require 'fzf-lua'.diagnostics_document() end, 'Document Diagnostics')
  map('<leader>sD', function() require 'fzf-lua'.diagnostics_workspace() end, 'Workspace Diagnostics')
  del('n', '[d')
  del('n', ']d')
  map('[d', function() vim.diagnostic.jump { count = -1, float = false } end, 'Previous Diagnostic')
  map(']d', function() vim.diagnostic.jump { count = 1, float = false } end, 'Next Diagnostic')
  map('[e', function() vim.diagnostic.jump { count = -1, float = false, severity = 'ERROR' } end, 'Previous Error')
  map(']e', function() vim.diagnostic.jump { count = 1, float = false, severity = 'ERROR' } end, 'Next Error')
  local filter = require 'utils.plugins'.symbols_filter
  map('<leader>ss', function()
    require 'fzf-lua'.lsp_document_symbols {
      regex_filter = filter,
    }
  end, 'Goto Symbol')
  map('<leader>sS', function()
    require 'fzf-lua'.lsp_live_workspace_symbols {
      regex_filter = filter,
    }
  end, 'Goto Symbol')
  map('[[', function() Snacks.words.jump(-vim.v.count1) end, 'Prev Reference')
  map(']]', function() Snacks.words.jump(vim.v.count1) end, 'Next Reference')
  Snacks.toggle.inlay_hints():map '<leader>uh'
  map({ 'n', 'i' }, '<c-h>', function()
    local r, c = unpack(vim.api.nvim_win_get_cursor(0))
    local l = vim.api.nvim_get_current_line()
    if l:sub(c + 1, c + 1) == '(' then
      vim.api.nvim_win_set_cursor(0, { r, c + 1 })
    end
    vim.defer_fn(vim.lsp.buf.signature_help, 1)
  end, 'Signature Help')

  -- remove native lsp keymaps
  for _, key in ipairs { 'ra', 'ri', 'rn', 'rr', 'rt', 'O' } do
    del('n', 'g' .. key)
  end
  del({ 'i', 's' }, '<c-s>')
  del('x', 'gra')

  if client:supports_method 'textDocument/formatting' then
    local grp = vim.api.nvim_create_augroup('LspFormat' .. buffer, { clear = true })
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = grp,
      buffer = buffer,
      callback = function()
        vim.lsp.buf.format { bufnr = buffer }
      end,
    })
  end

  if client:supports_method 'textDocument/documentSymbol' then
    local ok, navic = pcall(require, 'nvim-navic')
    if ok then
      navic.attach(client, buffer)
    end
  end

  local exclude = {
    'basedpyright',
    'pyright',
    -- 'zls'
  }

  if client:supports_method 'textDocument/inlayHint' and not vim.tbl_contains(exclude, client.name) then
    vim.defer_fn(function()
      vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
    end, 0)
  end
end

M.capabilities = vim.tbl_deep_extend(
  'force', {},
  vim.lsp.protocol.make_client_capabilities(),
  require 'blink.cmp'.get_lsp_capabilities()
)

return M
