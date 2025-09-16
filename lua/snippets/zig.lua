local ls = require 'luasnip'
local s = ls.snippet     -- or ls.s
local i = ls.insert_node -- or ls.i
local fmt = require 'luasnip.extras.fmt'.fmt
local rep = require 'luasnip.extras'.rep

return {
  -- list init
  s('li',
    fmt([[
    var {} = std.ArrayList({}).init({});
    defer {}.deinit();
    ]],
      {
        i(1), i(2), i(3), rep(1),
      }
    )
  ),

  -- expect
  s('ex', fmt([[ const expect = std.testing.expect;]], {})),

  -- test
  s('te',
    fmt([[
    try expect({});
    ]],
      {
        i(1)
      }
    )
  ),

  -- gpa
  s('gpa',
    fmt([[
    var gpa = std.heap.DebugAllocator(.{{}}){{}};
    defer {{
        const status = gpa.deinit();
        if (status == .leak) expect(false) catch @panic("TEST FAIL");
    }}]], {}
    )
  )
}
