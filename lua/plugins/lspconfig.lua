return {
  "neovim/nvim-lspconfig",
  ---@param opts PluginLspOpts
  opts = function(_, opts)
    local nosnippets = require('blink.cmp').get_lsp_capabilities({
      textDocument = {
        completion = {
          completionItem =
          {
            snippetSupport = false,
          },
        },
      },
    })
    local asm_lsp = {
      cmd = { 'asm-lsp' },
      filetypes = { 'asm', 's' },
      root_dir = function() return vim.fn.expand("~") end,
    }
    opts.servers["asm_lsp"] = asm_lsp
    opts.servers["clangd"].capabilities = vim.tbl_deep_extend("force", opts.servers["clangd"].capabilities, nosnippets)
  end
}
