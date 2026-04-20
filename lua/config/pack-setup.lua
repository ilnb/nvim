local M = {}

M.mod_to_spec = {} ---@type PackSpec[]
M.specs = {} ---@type table<string, PackSpec>
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

  if spec._opts then
    return spec._opts ---@type table
  end

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

---@param spec PackSpec
function M.load_plugin(spec)
  if not spec or M.loaded[spec.name] then return end

  -- handle deps
  for _, d in ipairs(spec.deps or {}) do
    local s = M.specs[d.name]
    M.load_plugin(s)
    if not M.loaded[s.name] then
      vim.notify('Dependency failed: ' .. s.name, log.ERROR)
      return
    end
  end

  local ok, _ = pcall(vim.cmd.packadd, spec.name)
  if not ok then
    vim.notify('Failed to packadd ' .. spec.name, log.ERROR)
    return
  end

  M.loaded[spec.name] = true
  M.run_setup(spec)
end

---@param spec PackSpec
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

  local ndeps = {}
  for _, d in ipairs(spec.deps or {}) do
    local t = type(d) == 'string' and { d } or d
    if not t or not t[1] then goto continue end
    t.name = M.make_name(t)
    table.insert(ndeps, t)
    M.add(t, true)

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

  is_lazy = is_lazy or spec.pfile == 'colors'

  if not is_lazy then
    M.load_plugin(spec)
  end
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

-- TODO: fix this function
---@param spec PackSpec
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

---@param spec PackSpec
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

---@param path string
function M.get_readme(path)
  if type(path) ~= 'string' or path == '' then return '' end

  for _, f in ipairs { 'README.md', 'README', 'Readme.md' } do
    local p = path .. '/' .. f
    if vim.fn.filereadable(p) then
      return p
    end
  end
  return path
end

function M.update()
  local lock_file = vim.fn.stdpath 'config' .. '/nvim-pack-lock.json'
  if vim.fn.filereadable(lock_file) == 0 then
    vim.notify('lockfile not found', log.INFO)
    return
  end

  local lock_data = vim.json.decode(table.concat(vim.fn.readfile(lock_file), '\n'))
  if not lock_data or not lock_data.plugins then
    vim.notify('corrupted lockfile', log.ERROR)
    return
  end

  local pack_info = {}
  for _, p in ipairs(vim.pack.get()) do
    pack_info[p.spec.name] = p
  end

  local entries, e_to_n = {}, {}

  local fzf = Pack.proxy 'fzf-lua'
  local utils = Pack.proxy 'fzf-lua.utils'

  ---@param path string?
  local function get_rev(path)
    if not path or path == '' then return nil end
    local f = io.popen('git -C ' .. vim.fn.shellescape(path) .. ' rev-parse origin/HEAD 2>/dev/null')
    if not f then return nil end
    local rev = f:read '*a':gsub('\n', '')
    f:close()
    return rev ~= '' and rev or nil
  end

  for name, info in pairs(lock_data.plugins) do
    local p = pack_info[name] or {}

    local cur_rev = get_rev(p.path)
    local lock_rev = info.rev
    local need_up = cur_rev and lock_rev and cur_rev ~= lock_rev

    local status = need_up and utils.ansi_codes.yellow '󰚰  ' or '   '
    local rev = utils.ansi_codes.green((info.rev or ''):sub(1, 7))
    local disp = utils.ansi_codes.blue(name)
    local entry = string.format('%s:1:1:%s[%s]  %s', M.get_readme(p.path), status, rev, disp)
    table.insert(entries, entry)
    e_to_n[utils.strip_ansi_coloring(entry)] = name
  end

  if #entries == 0 then
    vim.notify('no plugins to display', log.INFO)
    return
  end

  local function get_name(sel)
    if not sel or not sel[1] then
      return nil
    end
    return e_to_n[utils.strip_ansi_coloring(sel[1])]
  end

  fzf.fzf_exec(entries, {
    prompt = 'vim.pack> ',
    previewer = 'builtin',
    fzf_opts = {
      ['--delimiter'] = ':',
      ['--with-nth'] = '4..',
      ['--tiebreak'] = 'begin',
    },
    actions = {
      default = function(sel)
        local name = get_name(sel)
        local p = name and pack_info[name]
        if p and p.path and p.path ~= '' then
          vim.cmd('edit ' .. vim.fn.fnameescape(p.path))
        end
      end,
      ['ctrl-u'] = function(sel)
        local name = get_name(sel)
        if name then
          vim.notify('updating ' .. name)
          vim.system({ 'nvim', '--headless', '-c',
              string.format("lua vim.pack.update {'%s'} vim.cmd('wq')", name), '+q' },
            { text = true },
            function(obj)
              vim.schedule(function()
                if obj.code == 0 then
                  vim.notify('updated ' .. name, log.INFO)
                else
                  vim.notify('update failed for ' .. name .. ': ' .. (obj.stderr or ''), log.ERROR)
                end
              end)
            end)
        end
        fzf.resume()
      end,
      ['ctrl-x'] = function(sel)
        local name = get_name(sel)
        if not name then
          return
        end

        local p = vim.iter(vim.pack.get()):find(function(x)
          return x.spec.name == name
        end)

        if not p then
          vim.notify('plugin not found on disk ' .. name, log.WARN)
        elseif p.active then
          vim.notify('cannot delete active plugin ' .. name, log.ERROR)
        else
          vim.pack.del { name }
          vim.notify('deleted ' .. name, log.INFO)
        end
      end,
    }
  })
end

vim.api.nvim_create_user_command('PackUpdate', function()
  Pack.update()
end, {})

return M
