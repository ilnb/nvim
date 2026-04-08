vim.opt.packpath:prepend(vim.fn.stdpath 'data' .. '/site')

NeoVim.specs = {}

---@param str string
local function to_git(str)
  return 'https://github.com/' .. str
end

---@param spec table
local function make_name(spec)
  return spec.name or vim.split(spec[1], '/')[2]
end

local added = {}
local loaded = {}

---@param spec table
local function load_plugin(spec)
  if loaded[spec.name] then return end
  loaded[spec.name] = true
  local ok, _ = pcall(vim.cmd.packadd, spec.name)
  if not ok then return end
  if type(spec.config) == 'function' then
    if type(spec.opts) == 'function' then
      spec.opts = spec.opts()
    end
    spec.config(spec.opts or {})
  end
end

local function add(spec)
  local enabled = spec.enabled

  if type(enabled) == 'boolean' and not enabled then return end
  if not spec or not spec[1] then
    vim.notify("Found invalid spec", 3)
    return
  end

  if added[spec.name] then return end
  added[spec.name] = true

  NeoVim.specs[spec.name] = spec

  for _, d in ipairs(spec.deps or {}) do
    local t
    if type(d) == 'string' then
      t = { d }
    else
      t = d
    end

    if not t or not t[1] then goto continue end

    t.name = make_name(t)
    add(t)
    local ok, _ = pcall(vim.cmd.packadd, t.name)
    if not ok then
      vim.notify("Failed to packadd dependency: " .. t.name .. ' for plugin ' .. spec.name, vim.log.levels.DEBUG)
      return
    end
    if type(t.config) == 'function' then
      local options = t.opts
      if type(options) == 'function' then
        options = options()
      end
      t.config(options or {})
    end

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

  if not spec.lazy then
    local ok, _ = pcall(vim.cmd.packadd, spec.name)
    if not ok then return end
    if type(spec.config) == 'function' then
      if type(spec.opts) == 'function' then
        spec.opts = spec.opts()
      end
      spec.config(spec.opts or {})
    end
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
  vim.api.nvim_create_autocmd(spec.event, {
    once = true,
    callback = function()
      load_plugin(spec)
    end
  })
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

---@param spec table
local function on_cmd(spec)
  for _, cmd in ipairs(spec.cmd) do
    vim.api.nvim_create_user_command(cmd, function(opts)
      vim.api.nvim_del_user_command(cmd)
      load_plugin(spec)
      vim.schedule(function()
        local bang = opts.bang and "!" or ""
        local args = opts.args or ""
        vim.cmd(cmd .. bang .. " " .. args)
      end)
    end, {
      nargs = "*",
      bang = true,
    })
  end
end

---@param spec table
local function setup(spec)
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
  -- if not spec.config then vim.notify('No config for ' .. spec.name, 'info') end
  if type(spec.enabled) == 'boolean' and not spec.enabled then
    pcall(vim.pack.del, { spec.name })
  else
    setup(spec)
  end
end

vim.cmd.packadd 'nvim.undotree'

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
