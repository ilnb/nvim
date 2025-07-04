return {
  'NvChad/nvim-colorizer.lua',
  ft = { 'lua', 'css', 'html' },
  opts = {
    filetypes = { 'lua', 'css', 'html' }, -- enable for all filetypes
    user_default_options = {
      RGB = true,                         -- #RGB hex codes
      RRGGBB = true,                      -- #RRGGBB hex codes
      names = false,                      -- 'blue', 'red', etc
      css = true,                         -- enable all CSS features
      mode = 'foreground',                -- or 'foreground'
    },
  },
}
