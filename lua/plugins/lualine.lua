return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "SmiteshP/nvim-navic" },
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      -- set an empty statusline till lualine loads
      vim.o.statusline = " "
    else
      -- hide the statusline on the starter page
      vim.o.laststatus = 0
    end
  end,
  optional = true,
  opts = function()
    -- PERF: we don't need this lualine require madness 🤷
    require('lualine_require').require = require
    local icons = LazyVim.config.icons
    vim.o.laststatus = vim.g.lualine_laststatus

    local function custom_theme()
      local theme = {}
      if vim.g.colors_name and string.find(vim.g.colors_name, "material") then
        theme = require('lualine.themes.palenight')
        local overrides = {
          normal = {
            a = { bg = '#82B1FF' }, -- blue
            b = { fg = '#82B1FF' },
          },
          insert = {
            a = { bg = '#C3E88D' }, -- green
            b = { fg = '#C3E88D' },
          },
          visual = {
            a = { bg = '#C792EA' }, -- purple
            b = { fg = '#C792EA' },
          },
          inactive = {
            a = { bg = '#82B1FF' },
            b = { fg = '#82B1FF' },
            c = { fg = '#697098', bg = '#292D3E' },
          },
        }
        for mode, sections in pairs(overrides) do
          theme[mode] = vim.tbl_deep_extend("force", theme[mode] or {}, sections)
        end
      else
        theme = require('lualine.themes.kanagawa')
      end
      for _, mode in pairs({ "normal", "insert", "visual", "inactive" }) do
        theme[mode] = theme[mode] or {}
        theme[mode].c = theme[mode].c or {}
        theme[mode].c.bg = 'NONE'
      end
      return theme
    end

    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        require('lualine').setup({
          options = { theme = custom_theme() },
        })
      end
    })

    local function get_icon()
      local distro = "Arch"
      local handle = io.popen("cat /etc/*release 2>/dev/null | grep ^NAME=")
      if not handle then
        return "Arch"
      else
        distro = handle:read("*a")
        distro = distro:gsub('^NAME="?(.-)"?$', '%1')
        handle:close()
      end
      if distro:match("Ubuntu") then
        return ""
      elseif distro:match("Arch") then
        return ""
      elseif distro:match("Debian") then
        return ""
      elseif distro:match("Mint") then
        return "󰣭"
      end
      return ""
    end

    local opts = {
      options = {
        theme = custom_theme(),
        globalstatus = vim.o.laststatus == 3,
        disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },

        lualine_c = {
          {
            "diagnostics",
            symbols = {
              error = icons.diagnostics.Error,
              warn = icons.diagnostics.Warn,
              info = icons.diagnostics.Info,
              hint = icons.diagnostics.Hint,
            },
          },
          {
            "filetype",
            icon_only = true,
            separator = "",
            padding = { left = 1, right = 0 }
          },
          LazyVim.lualine.pretty_path(),
        },
        lualine_x = {
          Snacks.profiler.status(),
          -- stylua: ignore
          {
            function() return require("noice").api.status.command.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
            color = function() return { fg = Snacks.util.color("Statement") } end,
          },
          -- stylua: ignore
          {
            function() return require("noice").api.status.mode.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
            color = function() return { fg = Snacks.util.color("Constant") } end,
          },
          -- stylua: ignore
          {
            function() return "  " .. require("dap").status() end,
            cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
            color = function() return { fg = Snacks.util.color("Debug") } end,
          },
          -- stylua: ignore
          {
            require("lazy.status").updates,
            cond = require("lazy.status").has_updates,
            color = function() return { fg = Snacks.util.color("Special") } end,
          },
          {
            "diff",
            symbols = {
              added = icons.git.added,
              modified = icons.git.modified,
              removed = icons.git.removed,
            },
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
          },
          {
            function() return get_icon() end
          }
        },
        lualine_y = {
          {
            "progress",
            separator = " ",
            padding = { left = 1, right = 0 },
          },
          {
            "location",
            padding = { left = 0, right = 1 },
          },
        },
        lualine_z = {
          function()
            return " " .. os.date("%R")
          end,
        },
      },
      extensions = { "neo-tree", "lazy", "fzf" },
    }

    if not vim.g.trouble_lualine and LazyVim.has("trouble.nvim") then
      table.insert(opts.sections.lualine_c, { "navic", color_correction = "dynamic" })
    end

    -- do not add trouble symbols if aerial is enabled
    -- And allow it to be overriden for some buffer types (see autocmds)
    if vim.g.trouble_lualine and LazyVim.has("trouble.nvim") then
      local trouble = require("trouble")
      local symbols = trouble.statusline({
        mode = "symbols",
        groups = {},
        title = false,
        filter = { range = true },
        format = "{kind_icon}{symbol.name:Normal}",
        hl_group = "lualine_c_normal",
      })
      table.insert(opts.sections.lualine_c, {
        symbols and symbols.get,
        cond = function()
          return vim.b.trouble_lualine ~= false and symbols.has()
        end,
      })
    end

    return opts
  end,
}
