local M = {}

M.mod_to_spec = {}
M.specs = {}
M.loaded = {}
M.proxies = {}

local log = vim.log.levels

---@param modname string
function M.require(modname)
  if package.loaded[modname] then
    return package.loaded[modname]
  end
  local spec = M.mod_to_spec[modname]
  if spec and not M.loaded[spec.name] then
    M.load_plugin(spec)
  end
  return require(modname)
end

---@param modname string
function M.proxy(modname)
  if M.proxies[modname] then
    return M.proxies[modname]
  end

  local p = {}
  setmetatable(p, {
    __index = function(t, k)
      local mod = M.require(modname)
      local v = mod[k]
      t[k] = v
      return v
    end,
    __call = function(_, ...)
      local mod = M.require(modname)
      return mod(...)
    end
  })
  M.proxies[modname] = p
  return p
end

---@param str string
function M.to_git(str)
  return 'https://github.com/' .. str
end

---@param spec table
function M.make_name(spec)
  return spec.name or vim.split(spec[1], '/')[2]
end

---@param spec table
function M.run_setup(spec)
  local opts = spec.opts or {}
  if type(opts) == 'function' then opts = opts() end
  local config = spec.config
  local modname = spec.modname
  if config then
    if type(config) ~= 'function' then
      vim.notify(string.format('`config` for %s is not a function', spec.name), log.ERROR)
      M.loaded[spec.name] = nil
      return
    end
    config(opts)
  elseif modname then
    local ok, mod = pcall(require, modname)
    if not ok then
      vim.notify(string.format('Invalid `modname` %s for plugin %s', modname, spec.name), log.ERROR)
      M.loaded[spec.name] = nil
      return
    end
    mod.setup(opts)
  elseif not vim.tbl_isempty(opts) then
    vim.notify(
      string.format('`opts` for %s is not empty, but neither `modname` nor `config` to setup', spec.name),
      log.ERROR)
    return
  end
end

---@param spec table
function M.load_plugin(spec)
  if not spec or M.loaded[spec.name] then return end

  -- handle deps
  for _, d in ipairs(spec.deps or {}) do
    local name = type(d) == 'string' and M.make_name { d } or M.make_name(d)
    local s = M.specs[name]
    if s then
      M.load_plugin(s)
    else
      vim.notify(string.format('Spec not found for %s in M.specs table', name), log.ERROR)
      return
    end
  end

  M.loaded[spec.name] = true
  local ok, _ = pcall(vim.cmd.packadd, spec.name)
  if not ok then
    vim.notify('Failed to packadd ' .. spec.name, log.ERROR)
    return
  end
  M.run_setup(spec)
end

---@param spec table
---@param is_dep boolean?
function M.add(spec, is_dep)
  local enabled = spec.enabled

  if enabled ~= nil and not enabled then return end
  if not spec or not spec[1] then
    vim.notify('Found invalid spec', 3)
    return
  end

  if M.specs[spec.name] then return end
  M.specs[spec.name] = spec

  if spec.modname then
    M.mod_to_spec[spec.modname] = spec
  end

  for _, d in ipairs(spec.deps or {}) do
    local t = type(d) == 'string' and { d } or d
    if not t or not t[1] then goto continue end
    t.name = M.make_name(t)
    M.add(t, true)

    ::continue::
  end

  vim.pack.add({
    {
      src = M.to_git(spec[1]),
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
    M.load_plugin(spec)
  end
end

---@param spec table
function M.on_ft(spec)
  vim.api.nvim_create_autocmd('FileType', {
    pattern = spec.ft,
    once = true,
    callback = function()
      M.load_plugin(spec)
    end
  })
end

---@param spec table
function M.on_ev(spec)
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
        M.load_plugin(spec)
      end
    })
  end
end

---@param spec table
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

-- TODO: fix this function
---@param spec table
function M.on_cmd(spec)
  for _, cmd in ipairs(spec.cmd) do
    vim.api.nvim_create_user_command(cmd, function(opts)
      vim.api.nvim_del_user_command(cmd)
      M.load_plugin(spec)
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
function M.register(spec)
  M.add(spec)

  if spec.keys then
    M.on_key(spec)
  end
  if spec.event then
    M.on_ev(spec)
  end
  if spec.ft then
    M.on_ft(spec)
  end
  -- if spec.cmd then
  --   M.on_cmd(spec)
  -- end
end

return M
