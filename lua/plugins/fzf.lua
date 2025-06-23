return {
  'ibhagwan/fzf-lua',

  keys = {
    {
      '<leader>ff',
      function()
        require 'fzf-lua'.files {
          fd_opts = '-I -t f -E .git -H',
        }
      end,
      desc = 'Find Files (Root dir)',
      mode = { 'n', 'v' },
    },

    {
      '<leader>fh',
      function()
        vim.cmd [[e ~/.zsh_history]]
      end,
      desc = 'Terminal history',
      mode = { 'n', 'v' },
    },

    {
      '<leader>fs',
      function()
        vim.cmd [[e ~/.zshrc]]
      end,
      desc = 'Zsh config',
      mode = { 'n', 'v' },
    },

    { '<leader>fF', false },

    {
      '<leader>F',
      function()
        vim.cmd [[FzfLua]]
      end,
      desc = 'FzfLua',
      mode = { 'n', 'v' },
    },

    {
      '<leader>sB',
      function()
        local root = LazyVim.root.get()
        require 'fzf-lua'.blines { cwd = root }
      end,
      desc = 'Buffer lines',
      mode = 'n',
    },
    { '<leader>sw', false },
    { '<leader>sW', false },

    {
      '<leader>sb',
      function()
        local root = LazyVim.root.get()
        local mode = vim.api.nvim_get_mode().mode
        if mode == 'v' or mode == 'V' or mode == '\22' then
          require 'fzf-lua'.grep_visual { cwd = root }
        else
          require 'fzf-lua'.lgrep_curbuf { cwd = root }
        end
      end,
      desc = 'Buffer grep',
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
      desc = 'Find config file',
      mode = { 'n', 'v' },
    },
  }
}
