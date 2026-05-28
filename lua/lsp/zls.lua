---@type vim.lsp.Config
return {
  cmd = { 'zls' },
  root_markers = { 'zls.json', 'build.zig' },
  settings = {
    zls = {
      inlay_hints_hide_redundant_param_names = true,
      inlay_hints_exclude_single_argument = true
    },
  },
}
