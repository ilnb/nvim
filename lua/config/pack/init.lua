_G.Pack = require 'config.pack.setup'
Pack.stats.init()

local log = vim.log.levels

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

local builds = {
  ---@param ev vim.api.keyset.create_autocmd.callback_args
  ['nvim-treesitter'] = function(ev)
    if not ev.data.active then
      vim.cmd.packadd 'nvim-treesitter'
    end
    vim.cmd 'TSUpdate'
  end,

  ---@param ev vim.api.keyset.create_autocmd.callback_args
  ['blink.cmp'] = function(ev)
    if not ev.data.active then
      vim.pack.add { 'saghen/blink.lib', 'saghen/blink.cmp' }
    end

    local build_fn = function()
      vim.defer_fn(function()
        require 'blink.cmp'.build()
      end, 50)
    end

    if vim.v.vim_did_enter == 1 then
      build_fn()
    else
      vim.api.nvim_create_autocmd('UIEnter', {
        once = true,
        callback = build_fn
      })
    end
  end,
}

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    vim.schedule(function()
      local name = ev.data.spec.name
      local kind = ev.data.kind
      if kind == 'install' or kind == 'update' then
        local fn = builds[name]
        if fn then
          fn(ev)
        end
      end
    end)
  end,
})

vim.keymap.set('n', '<leader>L', Pack.update, { desc = 'Pack update', silent = true })

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
