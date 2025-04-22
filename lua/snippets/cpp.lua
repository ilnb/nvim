local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  -- base init
  s("nc",
    fmt([[
    #include <iostream>

    int main() {{
      {}

      return 0;
    }}
    ]],
      {
        i(1),
      }
    )
  ),

  -- for
  s("fr",
    fmt([[
    for ({}; {}; {}) {{
      {}
    }}
    ]],
      {
        i(1, "init"),
        i(2, "cond"),
        i(3, "incr"),
        i(4)
      }
    )
  ),

  -- while
  s("wh",
    fmt([[
    while ({}) {{
      {}
    }}
    ]],
      {
        i(1, "cond"), i(2)
      }
    )
  ),

  -- if
  s("if",
    fmt([[
    if ({}) {{
      {}
    }}
    ]],
      {
        i(1, "cond"), i(2)
      }
    )
  ),

  -- else if
  s("ef",
    fmt([[
    else if ({}) {{
      {}
    }}
    ]],
      {
        i(1, "cond"), i(2)
      }
    )
  ),
}
