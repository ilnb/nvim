local ls = require 'luasnip'
local s = ls.snippet     -- or ls.s
local i = ls.insert_node -- or ls.i
local fmt = require 'luasnip.extras.fmt'.fmt

return {
  -- base init
  s('z',
    fmt([[
    #include <stdio.h>

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

  -- typedef struct
  s('ts',
    fmt([[
    typedef struct {} {{
      {}
    }} {};
    ]],
      {
        i(1), i(2), i(3)
      }
    )
  ),

  -- struct
  s('st',
    fmt([[
    struct {} {{
      {}
    }};
    ]],
      {
        i(1), i(2)
      }
    )
  ),

  -- for
  s('fr',
    fmt([[
    for ({}; {}; {})
      {}
    ]],
      {
        i(1), i(2), i(3), i(4)
      }
    )
  ),

  -- while
  s('wh',
    fmt([[
    while ({})
      {}
    ]],
      {
        i(1), i(2)
      }
    )
  ),

  -- if
  s('if',
    fmt([[
    if ({})
      {}
    ]],
      {
        i(1), i(2)
      }
    )
  ),

  -- else if
  s('ef',
    fmt([[
    else if ({})
      {}
    ]],
      {
        i(1), i(2)
      }
    )
  ),

  -- else
  s('el',
    fmt([[
    else
      {}
    ]],
      {
        i(1),
      }
    )
  ),

  -- main
  s('m',
    fmt([[
    int main({}) {{
      {}
      return 0;
    }}
    ]],
      {
        i(1), i(2)
      }
    )
  ),

  -- function
  s('fn',
    fmt([[
    {} {}({})
    ]],
      {
        i(1), i(2), i(3)
      }
    )
  ),
}
