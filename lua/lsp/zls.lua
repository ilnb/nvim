return {
  cmd = { 'zls' },
  filetypes = { 'zig', 'zir' },
  root_markers = { 'zls.json', 'build.zig', '.git' },
  settings = {
    zls = {
      inlay_hints_hide_redundant_param_names = true,
      inlay_hints_exclude_single_argument = true
    },
  },
}
