local ffi = require 'ffi'
local M = {}

M.startuptime = 0
M.cputime = 0

if M._C == nil then
  pcall(function()
    ffi.cdef([[
      typedef int clockid_t;
      typedef struct timespec {
        int64_t tv_sec;
        long    tv_nsec;
      } nanotime;
      int clock_gettime(clockid_t clk_id, struct timespec *tp);
    ]])
    M._C = ffi.C
  end)
end

function M._cputime()
  local CLOCK_PROCESS_CPUTIME_ID = jit.os == 'OSX' and 12 or 2
  local t = ffi.new 'nanotime[1]'
  M._C.clock_gettime(CLOCK_PROCESS_CPUTIME_ID, t)
  -- in ms
  return tonumber(t[0].tv_sec) * 1e3 + tonumber(t[0].tv_nsec) / 1e6
end

function M._wallclock()
  return (vim.uv.hrtime() - M._start_hr) / 1e6
end

setmetatable(M, {
  __index = function(_, k)
    if k == 'count' then
      return vim.tbl_count(Pack.specs)
    elseif k == 'loaded' then
      return vim.tbl_count(Pack.loaded)
    end
  end
})

function M.init()
  M._start_hr = vim.uv.hrtime()
  vim.api.nvim_create_autocmd('UIEnter', {
    once = true,
    callback = function()
      M.startuptime = M._wallclock()
      M.cputime = M._cputime()
    end,
  })
end

return M
