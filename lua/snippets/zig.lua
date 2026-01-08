local ls = require 'luasnip'
local s = ls.snippet     -- or ls.s
local i = ls.insert_node -- or ls.i
local fmt = require 'luasnip.extras.fmt'.fmt
local rep = require 'luasnip.extras'.rep

return {
  -- list gpa
  s('lig',
    fmt([[
    var {} = try std.ArrayList({}).initCapacity({}, {});
    defer {}.deinit({});
    ]],
      {
        i(1), i(2), i(3), i(4),
        rep(1), rep(3),
      }
    )
  ),

  -- list empty
  s('li',
    fmt([[
    var {}: std.ArrayList({}) = .empty;
    defer {}.deinit({});
    ]],
      {
        i(1), i(2),
        rep(1), i(3),
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
    }}
    const ga = gpa.allocator();]], {}
    )
  ),

  -- fba
  s('fba',
    fmt([[
    var {}: [{}]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&{});
    const fa = fba.allocator();
    ]],
      {
        i(1), i(2), rep(1)
      }
    )
  ),

  -- stdin
  s('sti',
    fmt([[
    var stdin_buf: [{}]u8 = undefined;
    var stdin_reader = std.fs.File.stdin().reader(&stdin_buf);
    const stdin = &stdin_reader.interface;
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

  -- stdout print with flush
  s('spf',
    fmt([[
    try stdout.print("{}", .{{{}}});
    try stdout.flush();
    ]],
      {
        i(1), i(2),
      }
    )
  ),

  -- file open
  s('fo',
    fmt([[
    const {} = try std.fs.cwd().openFile("{}", .{{ .mode = {} }});
    defer {}.close();
    var {}_buf: [{}]u8 = undefined;
    var {}_r = {}.reader(&{}_buf);
    const {} = &{}_r.interface;
    ]],
      {
        i(1), i(2), i(3),
        rep(1),
        rep(1), i(4),
        rep(1), rep(1), rep(1),
        i(5), rep(1)
      }
    )
  ),

  -- init
  s('z',
    fmt([[
    const std = @import("std");{}

    pub fn main() !void {{
        {}
    }}
    ]],
      {
        i(1), i(2),
      }
    )
  ),

}
