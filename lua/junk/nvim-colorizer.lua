return {
  'NvChad/nvim-colorizer.lua',
  ft = { 'lua', 'css', 'html' },
  opts = function()
    Snacks.toggle.new {
      id = 'colorizer',
      name = 'Colorizer',
      set = function(state)
        if state then
          vim.cmd [[ColorizerAttachToBuffer]]
        else
          vim.cmd [[ColorizerDetachFromBuffer]]
        end
        vim.b.colorizer_enabled = state
      end,
      get = function()
        return vim.b.colorizer_enabled == true
      end
    }:map '<leader>uc'
    return {
      filetypes = { 'lua', 'css', 'html' }, -- enable for all filetypes
      user_default_options = {
        RGB = true,                         -- #RGB hex codes
        RRGGBB = true,                      -- #RRGGBB hex codes
        names = false,                      -- 'blue', 'red', etc
        css = true,                         -- enable all CSS features
        mode = 'foreground',                -- or 'foreground'
      },
    }
  end,
}
