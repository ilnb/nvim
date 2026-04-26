local ffi = require 'ffi'
local M = {}

M.startuptime = 0
M.real_cputime = false
M._ = {}

function M._.real()
  local CLOCK_PROCESS_CPUTIME_ID = jit.os == 'OSX' and 12 or 2
  local t = ffi.new 'nanotime[1]'
  M._.C.clock_gettime(CLOCK_PROCESS_CPUTIME_ID, t)
  -- in ms
  return tonumber(t[0].tv_sec) * 1e3 + tonumber(t[0].tv_nsec) / 1e6
end

function M._.fallback()
  return (vim.uv.hrtime() - M._.start_hr) / 1e6
end

local ok, _ = pcall(M._.real)
if ok then
  M.cputime = M._.real
  M.real_cputime = true
else
  M.cputime = M._.fallback
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
  M._.start_hr = vim.uv.hrtime()
  vim.api.nvim_create_autocmd('UIEnter', {
    once = true,
    callback = function()
      M.startuptime = M.cputime()
    end,
  })
end

return M
