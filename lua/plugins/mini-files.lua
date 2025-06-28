return {
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
        require 'mini.files'.open(vim.api.nvim_buf_get_name(0), true)
      end,
      desc = 'Open mini.files (Directory of Current File)',
    },
    {
      '<leader>fM',
      function()
        require 'mini.files'.open(vim.uv.cwd(), true)
      end,
      desc = 'Open mini.files (cwd)',
    },
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
      require 'mini.files'.refresh({ content = { filter = new_filter } })
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
        local buf_id = args.data.buf_id
        vim.keymap.set(
          'n',
          opts.mappings and opts.mappings.toggle_hidden or 'g.',
          toggle_dotfiles,
          { buffer = buf_id, desc = 'Toggle hidden files' }
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
}
