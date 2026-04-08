vim.opt.packpath:prepend(vim.fn.stdpath 'data' .. '/site')

NeoVim.specs = {}
NeoVim.loaded = {}
local mod_to_spec = {}

local load_plugin

do
  local origin = require
  _G.require = function(modname)
    if package.loaded[modname] then
      return package.loaded[modname]
    end
    local spec = mod_to_spec[modname]
    if spec and not NeoVim.loaded[spec.name] then
      load_plugin(spec)
    end
    return origin(modname)
  end
end

---@param str string
local function to_git(str)
  return 'https://github.com/' .. str
end

---@param spec table
local function make_name(spec)
  return spec.name or vim.split(spec[1], '/')[2]
end

local function run_setup(spec)
  local opts = spec.opts or {}
  if type(opts) == 'function' then opts = opts() end
  local modname = spec.modname
  local config = spec.config
  if modname then
    local ok, mod = pcall(require, modname)
    if not ok then
      vim.notify(string.format('Invalid `modname` %s for plugin %s', modname, spec.name), vim.log.levels.ERROR)
      NeoVim.loaded[spec.name] = nil
      return
    end
    mod.setup(opts)
  elseif config then
    if type(config) ~= 'function' then
      vim.notify(string.format('`config` for %s is not a function', spec.name), vim.log.levels.ERROR)
      NeoVim.loaded[spec.name] = nil
      return
    end
    config(opts)
  elseif not vim.tbl_isempty(opts) then
    vim.notify(
      string.format('`opts` for %s is not empty, but neither `modname` nor `config` to setup', spec.name),
      vim.log.levels.ERROR)
    return
  end
end

---@param spec table
function load_plugin(spec)
  if not spec or NeoVim.loaded[spec.name] then return end

  -- handle deps
  for _, d in ipairs(spec.deps or {}) do
    local name = type(d) == 'string' and make_name { d } or make_name(d)
    local s = NeoVim.specs[name]
    if s then
      load_plugin(s)
    else
      vim.notify(string.format('Spec not found for %s in NeoVim.specs table', name), vim.log.levels.ERROR)
      return
    end
  end

  NeoVim.loaded[spec.name] = true
  local ok, _ = pcall(vim.cmd.packadd, spec.name)
  if not ok then
    vim.notify('Failed to packadd ' .. spec.name, vim.log.levels.ERROR)
    return
  end
  run_setup(spec)
end

---@param spec table
---@param is_dep boolean
local function add(spec, is_dep)
  local enabled = spec.enabled

  if enabled ~= nil and not enabled then return end
  if not spec or not spec[1] then
    vim.notify('Found invalid spec', 3)
    return
  end

  if NeoVim.specs[spec.name] then return end
  NeoVim.specs[spec.name] = spec

  if spec.modname then
    mod_to_spec[spec.modname] = spec
  end

  for _, d in ipairs(spec.deps or {}) do
    local t = type(d) == 'string' and { d } or d
    if not t or not t[1] then goto continue end
    t.name = make_name(t)
    add(t, true)

    ::continue::
  end

  vim.pack.add({
    {
      src = to_git(spec[1]),
      name = spec.name,
    }
  }, { load = false })

  if spec.init then
    spec.init()
  end

  local is_lazy = spec.lazy
  if is_lazy == nil then
    local has_triggers = (false
      or spec.keys
      or spec.ft
      or spec.event
    -- or spec.cmd
    ) ~= nil
    if is_dep then
      is_lazy = true
    else
      is_lazy = has_triggers
    end
  end

  if not is_lazy then
    load_plugin(spec)
  end
end

---@param spec table
local function on_ft(spec)
  vim.api.nvim_create_autocmd('FileType', {
    pattern = spec.ft,
    once = true,
    callback = function()
      load_plugin(spec)
    end
  })
end

---@param spec table
local function on_ev(spec)
  local events = type(spec.event) == 'string' and { spec.event } or spec.event
  for _, e in ipairs(events) do
    local p
    if e == 'VeryLazy' then
      e = 'User'
      p = 'VeryLazy'
    end
    vim.api.nvim_create_autocmd(e, {
      pattern = p,
      once = true,
      callback = function()
        load_plugin(spec)
      end
    })
  end
end

---@param spec table
local function on_key(spec)
  for _, key in ipairs(spec.keys) do
    local lhs = key[1]
    local m = type(key.mode) == 'table' and key.mode or { key.mode or 'n' }
    local opts = vim.tbl_extend('force', {}, key)
    opts[1], opts[2], opts.mode, opts.ft = nil, nil, nil, nil
    opts.silent = opts.silent ~= false

    vim.keymap.set(m, lhs, function()
      -- load when needed
      load_plugin(spec)
      for _, k in ipairs(spec.keys) do
        local k_lhs, k_rhs = k[1], k[2]
        local k_modes = type(k.mode) == 'table' and k.mode or { k.mode or 'n' }
        local k_opts = vim.tbl_extend('force', {}, k)
        k_opts[1], k_opts[2], k_opts.mode, k_opts.ft = nil, nil, nil, nil
        pcall(vim.keymap.del, k_modes, k_lhs)
        vim.keymap.set(k_modes, k_lhs, k_rhs, k_opts)
      end
      local feed = vim.api.nvim_replace_termcodes(lhs, true, true, true)
      vim.api.nvim_feedkeys(feed, 'm', true)
    end, opts)
  end
end

-- TODO: fix this function
---@param spec table
local function on_cmd(spec)
  for _, cmd in ipairs(spec.cmd) do
    vim.api.nvim_create_user_command(cmd, function(opts)
      vim.api.nvim_del_user_command(cmd)
      load_plugin(spec)
      vim.schedule(function()
        local bang = opts.bang and '!' or ''
        local args = opts.args or ''
        vim.cmd(cmd .. bang .. ' ' .. args)
      end)
    end, {
      nargs = '*',
      bang = true,
    })
  end
end

---@param spec table
local function register(spec)
  add(spec)

  if spec.keys then
    on_key(spec)
  end
  if spec.event then
    on_ev(spec)
  end
  if spec.ft then
    on_ft(spec)
  end
  -- if spec.cmd then
  --   on_cmd(spec)
  -- end
end

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
    vim.notify('Error when trying to load ' .. file, vim.log.levels.WARN)
    goto continue
  end
  if vim.islist(mod) then
    for _, m in ipairs(mod) do
      table.insert(specs, m)
    end
  else
    table.insert(specs, mod)
  end
  ::continue::
end

for _, spec in ipairs(specs) do
  spec.name = make_name(spec)
  if type(spec.event) == 'string' then
    spec.event = { spec.event }
  end
  if spec.enabled ~= nil and not spec.enabled then
    pcall(vim.pack.del, { spec.name })
  else
    register(spec)
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
        vim.notify('Blink build failed', vim.log.levels.ERROR)
      end)
    else
      vim.notify('Blink build successful!', vim.log.levels.INFO);
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
