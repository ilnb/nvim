local ffi = require 'ffi'
local M = {}

M._stats = {
  startuptime = 0,
  real_cputime = false,
  count = 0,
  loaded = 0,
}

function M.cputime()
  if M.C == nil then
    pcall(function()
      ffi.cdef [[
      typedef int clockid_t;
      typedef struct nanotime {
        int64_t tv_sec;
        long    tv_nsec;
      } nanotime;
      int clock_gettime(clockid_t clk_id, nanotime *tp);
    ]]
      M.C = ffi.C
    end)
  end

  local function real()
    local CLOCK_PROCESS_CPUTIME_ID = jit.os == 'OSX' and 12 or 2
    local t = ffi.new 'nanotime[1]'
    M.C.clock_gettime(CLOCK_PROCESS_CPUTIME_ID, t)
    -- in ms
    return tonumber(t[0].tv_sec) * 1e3 + tonumber(t[0].tv_nsec) / 1e6
  end

  local function fallback()
    return (vim.uv.hrtime() - M._start) / 1e6
  end

  local ok, ret = pcall(real)
  if ok then
    M.cputime = real
    M._stats.real_cputime = true
    return ret
  else
    M.cputime = fallback
    return fallback()
  end
end

function M.init()
  M._start = vim.uv.hrtime()
  vim.api.nvim_create_autocmd('UIEnter', {
    once = true,
    callback = function()
      M._stats.startuptime = M.cputime()
    end,
  })
end

function M.stats()
  M._stats.count = vim.tbl_count(Pack.specs)
  M._stats.loaded = vim.tbl_count(Pack.loaded)
  return M._stats
end

return M
