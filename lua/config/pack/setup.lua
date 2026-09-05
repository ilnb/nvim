local M = {}

---@class Map<T>
---@field [string]T

M.mod_to_spec = {} ---@type PackSpec[]
M.specs = {} ---@type Map<PackSpec>
M.loaded = {} ---@type Map<boolean>
M.proxies = {} ---@type table
M.del_list = {} ---@type Map<boolean>
M.disabled = {} ---@type Map<string>
M.stats = require 'config.pack.stats'

local log = vim.log.levels
local pack_opt = vim.fs.joinpath(vim.fn.stdpath 'data', 'site', 'pack', 'core', 'opt')

---@param modname string
function M.require(modname)
  if package.loaded[modname] then
    return package.loaded[modname]
  end
  local spec = M.mod_to_spec[modname]
  if spec and not M.loaded[spec.name] then
    M.load_plugin(spec)
  end
  local ok, mod = pcall(require, modname)
  if not ok then
    vim.notify('Failed to require ' .. modname, log.ERROR)
    return nil
  end
  return mod
end

---@param modname string
function M.proxy(modname)
  if M.proxies[modname] then
    return M.proxies[modname]
  end

  local p = {}
  setmetatable(p, {
    __index = function(_, k)
      local mod = M.require(modname)
      if not mod then
        vim.notify('Failed to load module: ' .. modname, log.ERROR)
        return nil
      end
      M.proxies[modname] = mod
      return mod[k]
    end,
    __call = function(_, ...)
      local mod = M.require(modname)
      if not mod then
        vim.notify('Failed to load module: ' .. modname, log.ERROR)
        return nil
      end
      return mod(...)
    end
  })
  M.proxies[modname] = p
  return p
end

---@param x PackSpec|string
function M.make_name(x)
  if type(x) == 'table' then
    return x.name or vim.split(x[1], '/')[2]
  elseif type(x) == 'string' then
    return vim.split(x, '/')[2]
  end
  vim.notify('Invalid argument to make_name: ' .. tostring(x), log.ERROR)
end

---@param x PackSpec|string
function M.get_opts(x)
  local name
  if type(x) == 'table' then
    name = x.name or x.modname
  elseif type(x) == 'string' then
    name = x
  else
    name = 'invalid'
  end

  local spec ---@type PackSpec?
  if type(x) == 'table' then
    spec = x
  elseif type(x) == 'string' then
    spec = M.mod_to_spec[x] or M.specs[x]
  end
  if not spec then
    vim.notify('Spec not found for ' .. name, log.ERROR)
    return {}
  end

  if spec._opts then return spec._opts end

  local opts = spec.opts or {}
  if type(opts) == 'function' then
    local ok, res = pcall(opts)
    if not ok then
      vim.notify('opts() failed for ' .. name, log.ERROR)
      return {}
    end
    opts = res
  end

  spec._opts = opts
  return opts
end

---@param spec PackSpec
function M.run_setup(spec)
  local opts = M.get_opts(spec)
  local config = spec.config
  local modname = spec.modname
  if config then
    if type(config) ~= 'function' then
      vim.notify(('`config` for %s is not a function'):format(spec.name), log.ERROR)
      M.loaded[spec.name] = nil
      return
    end
    config(opts)
  elseif modname then
    local ok, mod = pcall(require, modname)
    if not ok then
      vim.notify(('Invalid `modname` %s for plugin %s'):format(modname, spec.name), log.ERROR)
      M.loaded[spec.name] = nil
      return
    end
    mod.setup(opts)
  elseif not vim.tbl_isempty(opts) then
    vim.notify(
      ('`opts` for %s is not empty, but neither `modname` nor `config` to setup'):format(spec.name),
      log.ERROR)
    return
  end
end

---@param plugin string
function M.load(plugin)
  M.load_plugin(M.mod_to_spec[plugin] or M.specs[plugin])
end

---@param spec PackSpec?
function M.load_plugin(spec)
  if not spec or M.loaded[spec.name] then return end
  if M.disabled[spec.name] then
    vim.notify('load of ' .. spec.name .. ' skipped [disabled]', log.WARN)
    return
  end

  -- handle deps
  for _, d in ipairs(spec.deps or {}) do
    local s = M.specs[d.name]
    if s then
      M.load_plugin(s)
      if not M.loaded[s.name] then
        vim.notify('Dependency failed: ' .. s.name, log.ERROR)
        return
      end
    else
    end
  end

  vim.cmd.packadd(spec.name)

  M.loaded[spec.name] = true
  M.run_setup(spec)
end

---@param spec PackSpec
---@param is_dep boolean?
---@param parent string?
---@return PackSpec?
function M.add(spec, is_dep, parent)
  spec.name = M.make_name(spec)
  local who = parent or spec.name

  if spec.enabled == false then
    if M.specs[spec.name] then
      vim.notify(('disable of %s by %s ignored (already enabled)'):format(spec.name, who), log.WARN)
      return M.specs[spec.name]
    end
    if not M.disabled[spec.name] then
      M.disabled[spec.name] = who
      if vim.uv.fs_stat(vim.fs.joinpath(pack_opt, spec.name)) then
        M.del_list[spec.name] = true
      end
    end
    return nil
  end

  if M.disabled[spec.name] then
    local prev = M.disabled[spec.name]
    M.disabled[spec.name] = nil
    M.del_list[spec.name] = nil
    vim.notify(('disable of %s by %s revoked (enabled by %s)'):format(spec.name, prev, who), log.WARN)
  end

  if M.specs[spec.name] then return M.specs[spec.name] end
  M.specs[spec.name] = spec

  if spec.modname then M.mod_to_spec[spec.modname] = spec end

  local ndeps = {}
  for _, d in ipairs(spec.deps or {}) do
    local t = type(d) == 'string' and { d } or d
    if not t[1] then goto continue end
    local c = M.add(t, true, spec.name)
    if c then table.insert(ndeps, c) end
    -- Intentional disable (sole owner) is silent: conflict notifies happen
    -- at the revoke/ignore sites in M:add, where both sides are known.

    ::continue::
  end
  spec.deps = ndeps

  ---@param str string
  local function to_git(str)
    return 'https://github.com/' .. str
  end

  vim.pack.add({
    {
      src = to_git(spec[1]),
      name = spec.name,
    }
  }, { load = false })

  if spec.init then spec.init() end

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

  is_lazy = is_lazy or spec.pfile == 'colors'
  spec.lazy = is_lazy

  if not is_lazy then
    M.load_plugin(spec)
  end
  return spec
end

---@param spec PackSpec
function M.on_ft(spec)
  vim.api.nvim_create_autocmd('FileType', {
    pattern = spec.ft,
    once = true,
    callback = function()
      M.load_plugin(spec)
    end
  })
end

---@param spec PackSpec
function M.on_ev(spec)
  for _, e in ipairs(spec.event) do
    local p
    if e == 'VeryLazy' then
      e, p = 'User', 'VeryLazy'
    end
    vim.api.nvim_create_autocmd(e, {
      pattern = p,
      once = true,
      callback = function()
        M.load_plugin(spec)
      end
    })
  end
end

---@param spec PackSpec
function M.on_key(spec)
  for _, key in ipairs(spec.keys) do
    local lhs = key[1]
    local m = type(key.mode) == 'table' and key.mode or { key.mode or 'n' }
    local opts = vim.tbl_extend('force', {}, key)
    opts[1], opts[2], opts.mode, opts.ft = nil, nil, nil, nil
    opts.silent = opts.silent ~= false

    vim.keymap.set(m, lhs, function()
      -- load when needed
      M.load_plugin(spec)
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

---@param spec PackSpec
function M.on_cmd(spec)
  for _, cmd in ipairs(spec.cmd) do
    vim.api.nvim_create_user_command(cmd, function(opts)
      vim.api.nvim_del_user_command(cmd)
      M.load_plugin(spec)
      local bang = opts.bang and '!' or ''
      local args = opts.args or ''
      vim.cmd(cmd .. bang .. ' ' .. args)
    end, {
      nargs = '*',
      bang = true,
    })
  end
end

---@param spec PackSpec
function M.register(spec)
  local c = M.add(spec)
  -- Only the canonical owner registers triggers: avoids duplicates when a
  -- disabled alias returns the enabled canonical, or when a duplicate
  -- top-level definition resolves to the first canonical.
  if not c or c ~= spec then return end
  if spec.enabled == false or M.disabled[spec.name] then return end

  if spec.keys then M.on_key(spec) end
  if spec.event then M.on_ev(spec) end
  if spec.ft then M.on_ft(spec) end
  if spec.cmd then M.on_cmd(spec) end
end

vim.api.nvim_create_user_command('PackUpdate', function()
  vim.pack.update()
end, {})

return M
