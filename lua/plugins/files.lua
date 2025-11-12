return {
  {
    'ibhagwan/fzf-lua',
    cmd = 'FzfLua',
    keys = {
      { '<c-j>',           '<c-j>',                                                                             ft = 'fzf',                       mode = 't',         nowait = true },
      { '<c-k>',           '<c-k>',                                                                             ft = 'fzf',                       mode = 't',         nowait = true },
      { '<leader>:',       ':FzfLua command_history<cr>',                                                       desc = 'Command history' },
      { '<leader>F',       ':FzfLua<cr>',                                                                       desc = 'FzfLua',                  mode = { 'n', 'v' } },
      { '<leader><space>', function() require 'fzf-lua'.files { cwd = require 'utils.plugins'.get_root() } end, desc = 'Files (root dir)' },
      { '<leader>fb',      ':FzfLua buffers sort_mru=true sort_lastused=true<cr>',                              desc = 'Buffers' },
      { '<leader>ff',      function() require 'fzf-lua'.files { fd_opts = '-I -t f -E .git -H' } end,           desc = 'Files (cwd)',             mode = { 'n', 'v' } },
      { '<leader>fg',      ':FzfLua git_files<cr>',                                                             desc = 'Files (git-files)' },
      { '<leader>fh',      ':e ~/.zsh_history<cr>',                                                             desc = 'Terminal history' },
      { '<leader>fr',      ':FzfLua oldfiles<cr>',                                                              desc = 'Old files' },
      { '<leader>fs',      ':e ~/.zshrc<cr>',                                                                   desc = 'Zsh config' },
      { '<leader>gc',      ':FzfLua git_commits<CR>',                                                           desc = 'Commits' },
      { '<leader>gs',      ':FzfLua git_status<CR>',                                                            desc = 'Status' },
      { '<leader>s"',      ':FzfLua registers<cr>',                                                             desc = 'Registers' },
      { '<leader>sa',      ':FzfLua autocmds<cr>',                                                              desc = 'Auto commands' },
      { '<leader>sb',      ':FzfLua grep_curbuf<cr>',                                                           desc = 'Buffer grep' },
      { '<leader>sc',      ':FzfLua command_history<cr>',                                                       desc = 'Command history' },
      { '<leader>sC',      ':FzfLua commands<cr>',                                                              desc = 'Commands' },
      { '<leader>sh',      ':FzfLua help_tags<cr>',                                                             desc = 'Help pages' },
      { '<leader>sH',      ':FzfLua highlights<cr>',                                                            desc = 'Search highlight groups' },
      { '<leader>sj',      ':FzfLua jumps<cr>',                                                                 desc = 'Jumplist' },
      { '<leader>sk',      ':FzfLua keymaps<cr>',                                                               desc = 'Key maps' },
      { '<leader>sl',      ':FzfLua loclist<cr>',                                                               desc = 'Location list' },
      { '<leader>sm',      ':FzfLua marks<cr>',                                                                 desc = 'Jump to mark' },
      { '<leader>sM',      ':FzfLua man_pages<cr>',                                                             desc = 'Man pages' },
      { '<leader>sq',      ':FzfLua quickfix<cr>',                                                              desc = 'Quickfix list' },
      { '<leader>uC',      ':FzfLua colorschemes<cr>',                                                          desc = 'Colorscheme with preview' },

      {
        '<leader>sg',
        function()
          local mode = vim.api.nvim_get_mode().mode
          if mode:match '[vV\022]' then
            require 'fzf-lua'.grep_visual { cwd = require 'utils.plugins'.get_root() }
          else
            require 'fzf-lua'.live_grep { cwd = require 'utils.plugins'.get_root() }
          end
        end,
        desc = 'Grep (root dir)',
        mode = { 'n', 'v' },
      },

      {
        '<leader>fc',
        function()
          require 'fzf-lua'.files {
            cwd = vim.fn.stdpath 'config',
            actions = {
              default = function(selected, opts)
                if selected and #selected > 0 then
                  vim.cmd('tcd' .. vim.fn.stdpath 'config')
                  require 'fzf-lua'.actions.file_edit_or_qf(selected, opts)
                end
              end
            }
          }
        end,
        desc = 'Config files',
        mode = { 'n', 'v' },
      },
    },

    opts = function()
      local fzf = require 'fzf-lua'
      local config = fzf.config
      local actions = fzf.actions
      local keymap = config.defaults.keymap

      -- Quickfix
      keymap.fzf['ctrl-q'] = 'select-all+accept'
      keymap.fzf['ctrl-u'] = 'half-page-up'
      keymap.fzf['ctrl-d'] = 'half-page-down'
      keymap.fzf['ctrl-x'] = 'jump'
      keymap.fzf['ctrl-f'] = 'preview-page-down'
      keymap.fzf['ctrl-b'] = 'preview-page-up'
      keymap.builtin['<c-f>'] = 'preview-page-down'
      keymap.builtin['<c-b>'] = 'preview-page-up'

      local img_previewer ---@type string[]?
      for _, v in ipairs {
        { cmd = 'ueberzug', args = {} },
        { cmd = 'chafa',    args = { '{file}', '--format=symbols' } },
        { cmd = 'viu',      args = { '-b' } },
      } do
        if vim.fn.executable(v.cmd) == 1 then
          img_previewer = vim.list_extend({ v.cmd }, v.args)
          break
        end
      end

      return {
        'border-fused',
        fzf_colors = true,
        fzf_opts   = {
          ['--no-scrollbar'] = true,
        },
        defaults   = {
          -- formatter = 'path.filename_first',
          formatter = 'path.dirname_first',
        },
        previewers = {
          builtin = {
            extensions = {
              png = img_previewer,
              jpg = img_previewer,
              jpeg = img_previewer,
              gif = img_previewer,
              webp = img_previewer,
            },
            ueberzug_scaler = 'fit_contain',
          },
        },
        ui_select  = function(fzf_opts, items)
          return vim.tbl_deep_extend('force', fzf_opts, {
            prompt = ' ',
            winopts = {
              title = ' ' .. vim.trim((fzf_opts.prompt or 'Select'):gsub('%s*:%s*$', '')) .. ' ',
              title_pos = 'center',
            },
          }, fzf_opts.kind == 'codeaction' and {
            winopts = {
              layout = 'vertical',
              -- height is number of items minus 15 lines for the preview, with a max of 80% screen height
              height = math.floor(math.min(vim.o.lines * 0.8 - 16, #items + 2) + 0.5) + 16,
              width = 0.5,
              preview = not vim.tbl_isempty(require 'utils.lsp'.get_clients { bufnr = 0, name = 'vtsls' }) and {
                layout = 'vertical',
                vertical = 'down:15,border-top',
                hidden = 'hidden',
              } or {
                layout = 'vertical',
                vertical = 'down:15,border-top',
              },
            },
          } or {
            winopts = {
              width = 0.5,
              -- height is number of items, with a max of 80% screen height
              height = math.floor(math.min(vim.o.lines * 0.8, #items + 2) + 0.5),
            },
          })
        end,
        winopts    = {
          width = 0.8,
          -- height = 0.8,
          height = 0.5,
          -- row = 0.5,
          row = 1,
          col = 0.5,
          preview = {
            scrollchars = { '┃', '' },
          },
        },
        files      = {
          cwd_prompt = false,
          actions = {
            ['alt-i'] = { actions.toggle_ignore },
            ['alt-h'] = { actions.toggle_hidden },
          },
        },
        grep       = {
          actions = {
            ['alt-i'] = { actions.toggle_ignore },
            ['alt-h'] = { actions.toggle_hidden },
          },
        },
        lsp        = {
          symbols = {
            symbol_hl = function(s)
              return 'TroubleIcon' .. s
            end,
            symbol_fmt = function(s)
              return s:lower() .. '\t'
            end,
            child_prefix = false,
          },
          code_actions = {
            previewer = vim.fn.executable 'delta' == 1 and 'codeaction_native' or nil,
          },
        },
      }
    end,

    config = function(_, opts)
      if opts[1] == 'default-title' then
        -- use the same prompt for all pickers for profile `default-title` and
        -- profiles that use `default-title` as base profile
        local function fix(t)
          t.prompt = t.prompt ~= nil and ' ' or nil
          for _, v in pairs(t) do
            if type(v) == 'table' then
              fix(v)
            end
          end
          return t
        end
        opts = vim.tbl_deep_extend('force', fix(require 'fzf-lua.profiles.default-title'), opts)
        opts[1] = nil
      end
      require 'fzf-lua'.setup(opts)
    end,

    init = function()
      vim.api.nvim_create_autocmd('User', {
        pattern = 'VeryLazy',
        callback = function()
          vim.ui.select = function(...)
            require 'lazy'.load { plugins = { 'fzf-lua' } }
            local opts = require 'utils.plugins'.get_opts 'fzf-lua'
            require 'fzf-lua'.register_ui_select(opts.ui_select or nil)
            return vim.ui.select(...)
          end
        end
      })
    end,
  },

  {
    'echasnovski/mini.files',
    -- event = 'VeryLazy',
    opts = {
      windows = {
        max_number = 4,
        preview = true,
        width_focus = 30,
        width_preview = 30,
      },
      options = {
        use_as_default_explorer = false,
      },
    },

    keys = {
      {
        '<leader>fm',
        function()
          local path = vim.api.nvim_buf_get_name(0)
          local t
          if path == '' then
            t = vim.uv.cwd()
          else
            t = vim.fn.fnamemodify(path, ':h')
          end
          require 'mini.files'.open(t, true)
        end,
        desc = 'Open mini.files (%:h)',
      },
      { '<leader>fM', function() require 'mini.files'.open(vim.uv.cwd(), true) end, desc = 'Open mini.files (cwd)', },
    },

    config = function(_, opts)
      require 'mini.files'.setup(opts)

      local show_dotfiles = true
      local filter_show = function(fs_entry)
        return true
      end
      local filter_hide = function(fs_entry)
        return not vim.startswith(fs_entry.name, '.')
      end

      local toggle_dotfiles = function()
        show_dotfiles = not show_dotfiles
        local new_filter = show_dotfiles and filter_show or filter_hide
        require 'mini.files'.refresh { content = { filter = new_filter } }
      end

      local files_set_cwd = function()
        local cur_entry_path = MiniFiles.get_fs_entry().path
        local cur_directory = vim.fs.dirname(cur_entry_path)
        if cur_directory ~= nil then
          vim.fn.chdir(cur_directory)
        end
      end

      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesBufferCreate',
        callback = function(args)
          vim.keymap.set(
            'n',
            opts.mappings and opts.mappings.toggle_hidden or 'g.',
            toggle_dotfiles,
            { buffer = args.data.buf_id, desc = 'Toggle hidden files' }
          )
          vim.keymap.set(
            'n',
            opts.mappings and opts.mappings.change_cwd or 'gc',
            files_set_cwd,
            { buffer = args.data.buf_id, desc = 'Set cwd' }
          )
        end,
      })

      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesActionRename',
        callback = function(event)
          Snacks.rename.on_rename_file(event.data.from, event.data.to)
        end,
      })
    end,
  },

}
