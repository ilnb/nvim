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
        if (status == .leak) std.testing.expect(false) catch @panic("FAILURE");
    }}]], {}
    )
  ),

  -- stdin
  s('sti',
    fmt([[
    var stdin_buf: [{}]u8 = undefined;
    var stdin_writer = std.fs.File.stdin().reader(&stdin_buf);
    const stdin = &stdin_writer.interface;
    ]],
      {
        i(1)
      }
    )
  ),

  -- stdout
  s('sto',
    fmt([[
    var stdout_buf: [{}]u8 = undefined;
    var stdout_writer = std.fs.File.stdout().writer(&stdout_buf);
    const stdout = &stdout_writer.interface;
    ]],
      {
        i(1)
      }
    )
  ),

  -- stdout print
  s('stp',
    fmt([[
    try stdout.print("{}", .{{{}}});
    ]],
      {
        i(1), i(2),
      }
    )
  ),
}
