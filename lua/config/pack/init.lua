_G.Pack = require 'config.pack.setup':new()
Pack.stats.init()
require 'config.pack.options'

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

local to_build = {}
local running, ready

local function run_next()
  -- prevent lockfile from infiltrating
  if not ready then return end
  if running then return end
  local e = table.remove(to_build, 1)
  -- nothing to build
  if not e then
    running = false
    return
  end
  running = true

  local name, ev = unpack(e)
  local spec = Pack.specs[name] or Pack.mod_to_spec[name]

  local function done()
    running = false
    vim.schedule(run_next)
  end

  if not (spec and spec.build) then
    done()
    return
  end
  local ok, err = pcall(spec.build, ev)
  if not ok then
    vim.notify(('Build failed for %s:\n%s'):format(name, err), log.ERROR)
  else
    if spec.name:find 'blink' then
      pcall(spec.build, ev)
    end
  end
  done()
end

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name = ev.data.spec.name
    local kind = ev.data.kind
    if kind == 'install' or kind == 'update' then
      to_build[#to_build + 1] = { name, ev }
      run_next()
    end
  end,
})

local specs = {}

local order = {
  'colors',
  'ui',
  'lspconfig',
  'coding',
  'files',
  'misc',
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
  for _, v in ipairs { 'event', 'cmd', 'ft' } do
    if type(spec[v]) == 'string' then
      spec[v] = { spec[v] }
    end
  end
  Pack:register(spec)
end

-- finally start builds
ready = true
vim.api.nvim_create_autocmd('UIEnter', {
  once = true,
  callback = function()
    vim.defer_fn(
      function()
        run_next()
        local del = vim.tbl_keys(Pack.del_list)
        if #del > 0 then
          vim.pack.del(del)
        end
      end, 10)
  end
})
