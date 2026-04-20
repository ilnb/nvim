vim.opt.packpath:prepend(vim.fn.stdpath 'data' .. '/site')

local log = vim.log.levels

local specs = {}

local order = {
  'colors',
  'ui',
  'lspconfig',
  'coding',
  'files',
  'misc'
}

for _, file in ipairs(order) do
  local ok, mod = pcall(require, 'specs.' .. file)
  if not ok then
    vim.notify('Error when trying to load ' .. file, log.WARN)
    goto continue
  end
  if vim.islist(mod) then
    for _, m in ipairs(mod) do
      m.pfile = file
      table.insert(specs, m)
    end
  else
    mod.pfile = file
    table.insert(specs, mod)
  end
  ::continue::
end

for _, spec in ipairs(specs) do
  spec.name = Pack.make_name(spec)
  if type(spec.event) == 'string' then
    spec.event = { spec.event }
  end
  if type(spec.cmd) == 'string' then
    spec.cmd = { spec.cmd }
  end
  if type(spec.ft) == 'string' then
    spec.ft = { spec.ft }
  end
  if spec.enabled ~= nil and not spec.enabled then
    pcall(vim.pack.del, { spec.name })
  else
    Pack.register(spec)
  end
end

local builds = {
  ['nvim-treesitter'] = function(ev)
    if not ev.data.active then
      vim.cmd.packadd 'nvim-treesitter'
    end
    vim.cmd 'TSUpdate'
  end,

  ['blink.cmp'] = function(ev)
    local res = vim.system(
      { 'cargo', 'build', '--release' },
      { cwd = ev.data.path }
    ):wait()

    if res.code ~= 0 then
      vim.schedule(function()
        vim.notify('Blink build failed', log.ERROR)
      end)
    else
      vim.notify('Blink build successful!', log.INFO);
    end
  end,
}

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name = ev.data.spec.name
    local kind = ev.data.kind
    if kind == 'install' or kind == 'update' then
      local fn = builds[name]
      if fn then
        fn(ev)
      end
    end
  end,
})

local plugin_path = vim.fn.stdpath 'data' .. '/site/pack/core/opt/blink.cmp'
local binary = plugin_path .. '/target/release/libblink_cmp_fuzzy.so'
if vim.fn.filereadable(binary) == 0 then
  builds['blink.cmp'] { data = { path = plugin_path } }
end

vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  callback = function() end,
})

vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    vim.schedule(function()
      vim.api.nvim_exec_autocmds('User', { pattern = 'VeryLazy' })
    end)
  end
})

vim.keymap.set('n', '<leader>L', Pack.update, { desc = 'Pack update', silent = true })
