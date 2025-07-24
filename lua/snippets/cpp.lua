local ls = require 'luasnip'
local s = ls.snippet
local i = ls.insert_node
local fmt = require 'luasnip.extras.fmt'.fmt

return {
  -- base init
  s('z',
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
}
