return {
  "neovim/nvim-lspconfig",
  ---@param opts PluginLspOpts
  opts = function(_, opts)
    LazyVim.lsp.on_attach(function(client, buffer)
      if client:supports_method("textDocument/documentSymbol") then
        require("nvim-navic").attach(client, buffer)
      end
    end)
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
    opts.setup.clangd = function(_, opts)
      if vim.bo.filetype ~= "c" and vim.bo.filetype ~= "cpp" then
        return false
      end
      LazyVim.on_load("clangd_extensions.nvim", function()
        local clangd_ext_opts = LazyVim.opts("clangd_extensions.nvim")
        require("clangd_extensions").setup(vim.tbl_deep_extend("force", clangd_ext_opts or {}, { server = opts }))
      end)
      return true
    end
  end
}
