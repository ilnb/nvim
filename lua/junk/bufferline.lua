return {
  'akinsho/bufferline.nvim',
  event = 'VeryLazy',
  keys = {
    { '<leader>bp', ':BufferLineTogglePin<CR>',            desc = 'Toggle Pin' },
    { '<leader>bP', ':BufferLineGroupClose ungrouped<CR>', desc = 'Delete Non-Pinned Buffers' },
    { '<leader>br', ':BufferLineCloseRight<CR>',           desc = 'Delete Buffers to the Right' },
    { '<leader>bl', ':BufferLineCloseLeft<CR>',            desc = 'Delete Buffers to the Left' },
    { '<S-h>',      ':BufferLineCyclePrev<cr>',            desc = 'Prev Buffer' },
    { '<S-l>',      ':BufferLineCycleNext<cr>',            desc = 'Next Buffer' },
    { '[b',         ':BufferLineCyclePrev<cr>',            desc = 'Prev Buffer' },
    { ']b',         ':BufferLineCycleNext<cr>',            desc = 'Next Buffer' },
    { '[B',         ':BufferLineMovePrev<cr>',             desc = 'Move buffer prev' },
    { ']B',         ':BufferLineMoveNext<cr>',             desc = 'Move buffer next' },
  },
  opts = {
    options = {
      close_command = function(n) Snacks.bufdelete(n) end,
      right_mouse_command = function(n) Snacks.bufdelete(n) end,
      diagnostics = 'nvim_lsp',
      always_show_bufferline = false,
      diagnostics_indicator = function(_, _, diag)
        local icons = LazyVim.config.icons.diagnostics
        local ret = (diag.error and icons.Error .. diag.error .. ' ' or '')
            .. (diag.warning and icons.Warn .. diag.warning or '')
        return vim.trim(ret)
      end,
      offsets = {
        {
          filetype = 'neo-tree',
          text = 'Neo-tree',
          highlight = 'Directory',
          text_align = 'left',
        },
        {
          filetype = 'snacks_layout_box',
        },
      },
      ---@param opts bufferline.IconFetcherOpts
      get_element_icon = function(opts)
        return LazyVim.config.icons.ft[opts.filetype]
      end,
    },
  },
  config = function(_, opts)
    require 'bufferline'.setup(opts)
    -- Fix bufferline when restoring a session
    vim.api.nvim_create_autocmd({ 'BufAdd', 'BufDelete' }, {
      callback = function()
        vim.schedule(function()
          pcall(nvim_bufferline)
        end)
      end,
    })
  end,
}
