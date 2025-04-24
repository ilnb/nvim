local ls = require("luasnip")
local s = ls.snippet     -- or ls.s
local i = ls.insert_node -- or ls.i
local fmt = require("luasnip.extras.fmt").fmt

return {
  -- base init
  s("nc",
    fmt([[
    #include <stdio.h>
    #include <stdlib.h>

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

  -- struct
  s("ts",
    fmt([[
    typedef struct {} {{
      {}
    }} {};
    ]],
      {
        i(1, "name"), i(2, "def"), i(3, "name")
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
        i(1, "init"), i(2, "cond"), i(3, "incr"), i(4)
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

  -- else
  s("el",
    fmt([[
    else {{
      {}
    }}
    ]],
      {
        i(1),
      }
    )
  )
}
