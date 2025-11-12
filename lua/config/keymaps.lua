local map = vim.keymap.set
local del = vim.keymap.del

-- better up/down
map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
map({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })
map({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
map('n', '<c-h>', '<c-w>h', { desc = 'Go to left window', remap = true, silent = true })
map('n', '<c-j>', '<c-w>j', { desc = 'Go to lower window', remap = true, silent = true })
map('n', '<c-k>', '<c-w>k', { desc = 'Go to upper window', remap = true, silent = true })
map('n', '<c-l>', '<c-w>l', { desc = 'Go to right window', remap = true, silent = true })

-- Resize window using <ctrl> arrow keys
map('n', '<c-up>', ':resize +2<cr>', { desc = 'Increase window height', silent = true })
map('n', '<c-down>', ':resize -2<cr>', { desc = 'Decrease window height', silent = true })
map('n', '<c-left>', ':vertical resize -2<cr>', { desc = 'Decrease window width', silent = true })
map('n', '<c-right>', ':vertical resize +2<cr>', { desc = 'Increase window width', silent = true })

-- Move Lines
map('n', '<a-j>', ":execute 'move .+' . v:count1<cr>==", { desc = 'Move down', silent = true })
map('n', '<a-k>', ":execute 'move .-' . (v:count1 + 1)<cr>==", { desc = 'Move up', silent = true })
map('i', '<a-j>', '<esc>:m .+1<cr>==gi', { desc = 'Move down', silent = true })
map('i', '<a-k>', '<esc>:m .-2<cr>==gi', { desc = 'Move up', silent = true })
map('v', '<a-j>', ":<c-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = 'Move down', silent = true })
map('v', '<a-k>', ":<c-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = 'Move up', silent = true })

-- buffers
map('n', '<S-h>', ':bp<cr>', { desc = 'Prev buffer', silent = true })
map('n', '<S-l>', ':bn<cr>', { desc = 'Next buffer', silent = true })
map('n', '<leader>bb', ':e #<cr>', { desc = 'Switch to other buffer', silent = true })
map('n', '<leader>bd', function() Snacks.bufdelete() end, { desc = 'Delete buffer', silent = true })
map('n', '<leader>bh', ':bp<cr>', { desc = 'Prev buffer', silent = true })
map('n', '<leader>bl', ':bn<cr>', { desc = 'Next buffer', silent = true })
map('n', '<leader>bo', function() Snacks.bufdelete.other() end, { desc = 'Delete other buffers', silent = true })
map('n', '<leader>bD', ':bd<cr>', { desc = 'Delete buffer and window', silent = true })

-- Clear search highlight
map({ 'n', 's' }, '<esc>', function()
  vim.cmd 'noh'
  return '<esc>'
end, { expr = true, desc = 'Escape and clear hlsearch' })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
map('n', '<leader>ur',
  ':nohlsearch<Bar>diffupdate<Bar>normal! <c-L><cr>',
  { desc = 'Redraw / Clear hlsearch / Diff update' }
)

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map('n', 'n', "'Nn'[v:searchforward].'zv'", { expr = true, desc = 'Next search result', silent = true })
map('x', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result', silent = true })
map('o', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result', silent = true })
map('n', 'N', "'nN'[v:searchforward].'zv'", { expr = true, desc = 'Prev search result', silent = true })
map('x', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev search result', silent = true })
map('o', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev search result', silent = true })

-- Add undo break-points
map('i', ',', ',<c-g>u')
map('i', '.', '.<c-g>u')
map('i', ';', ';<c-g>u')

--keywordprg
map('n', '<leader>K', ':norm! K<cr>', { desc = 'Keywordprg', silent = true })

-- better indenting
map('v', '<', '<gv')
map('v', '>', '>gv')

-- commenting
map('n', 'gco', 'o<esc>Vcx<esc>:normal gcc<cr>fxa<bs>', { desc = 'Add comment below', silent = true })
map('n', 'gcO', 'O<esc>Vcx<esc>:normal gcc<cr>fxa<bs>', { desc = 'Add comment above', silent = true })

-- lazy
map('n', '<leader>L', ':Lazy<cr>', { desc = 'Lazy', silent = true })

-- new file
map('n', '<leader>fn', ':enew<cr>', { desc = 'New File', silent = true })

-- toggle options
Snacks.toggle.option('wrap', { name = 'Wrap' }):map '<leader>uw'
Snacks.toggle.option('relativenumber', { name = 'Relative number' }):map '<leader>uL'
Snacks.toggle.diagnostics():map '<leader>ud'
Snacks.toggle.line_number():map '<leader>ul'
Snacks.toggle.option('showtabline', { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = 'Tabline' })
    :map '<leader>uA'
Snacks.toggle.treesitter():map '<leader>uT'
Snacks.toggle.animate():map '<leader>ua'
Snacks.toggle.indent():map '<leader>ug'
Snacks.toggle.option('spell', { name = 'Spelling' }):map '<leader>us'
Snacks.toggle.scroll():map '<leader>uS'

map('n', '<leader>gb', function() Snacks.picker.git_log_line() end, { desc = 'Git blame line', silent = true })
map({ 'n', 'x' }, '<leader>gB', function() Snacks.gitbrowse() end, { desc = 'Git browse (open)', silent = true })
map({ 'n', 'x' }, '<leader>gY', function()
  Snacks.gitbrowse { open = function(url) vim.fn.setreg('+', url) end, notify = false }
end, { desc = 'Git browse (copy)' })

-- quit
map('n', '<leader>qq', ':qa<cr>', { desc = 'Quit all', silent = true })
map('n', '<leader>qw', ':wqa<cr>', { desc = 'Write and quit all', silent = true })
map({ 'n', 'v' }, '<leader>w', ':up<cr>', { desc = 'Write', silent = true })

-- highlights under cursor
map('n', '<leader>ui', vim.show_pos, { desc = 'Inspect pos', silent = true })
map('n', '<leader>uI', function()
  vim.treesitter.inspect_tree()
  vim.api.nvim_input 'I'
end, { desc = 'Inspect tree' })

-- floating terminal
map('n', '<leader>ft', function() Snacks.terminal() end, { desc = 'Terminal (cwd)', silent = true })

-- Terminal Mappings
map('t', '<c-/>', ':close<cr>', { desc = 'Hide terminal', silent = true })
map('t', '<c-_>', ':close<cr>', { desc = 'which_key_ignore', silent = true })

-- windows
map('n', '<leader>-', '<c-w>s', { desc = 'Split window below', remap = true, silent = true })
map('n', '<leader>|', '<c-w>v', { desc = 'Split window right', remap = true, silent = true })

-- tabs
map('n', '<leader>tl', ':tabl<cr>', { desc = 'Last tab', silent = true })
map('n', '<leader>to', ':tabo<cr>', { desc = 'Close other tabs', silent = true })
map('n', '<leader>tf', ':tabr<cr>', { desc = 'First tab', silent = true })
map('n', '<leader>tt', ':tabe<cr>', { desc = 'New tab', silent = true })
map('n', '<leader>tl', ':tabn<cr>', { desc = 'Next tab', silent = true })
map('n', '<leader>td', ':tabc<cr>', { desc = 'Close tab', silent = true })
map('n', '<leader>th', ':tabp<cr>', { desc = 'Previous tab', silent = true })

-- Add empty lines (grabbed from /runtime/vim/lua/_defaults.lua)
del('n', '[<space>')
del('n', ']<space>')
map('n', '<leader>o', function()
  vim.go.operatorfunc = "v:lua.require'vim._buf'.space_below"
  return 'g@l'
end, { expr = true, desc = 'Newline below' })

map('n', '<leader>O', function()
  vim.go.operatorfunc = "v:lua.require'vim._buf'.space_above"
  return 'g@l'
end, { expr = true, desc = 'Newline above' })

-- diagnostics keymaps
del('n', '<c-w><c-d>')
del('n', '<c-w>d')

-- pasting in visual mode doesn't reset the register
map('x', '<leader>p', '"_dP', { remap = false, silent = true })

-- typo fixes
vim.cmd [[
    cnoreabbrev W! w!
    cnoreabbrev W1 w!
    cnoreabbrev w1 w!
    cnoreabbrev Q! q!
    cnoreabbrev Q1 q!
    cnoreabbrev q1 q!
    cnoreabbrev Qa! qa!
    cnoreabbrev Qall! qall!
    cnoreabbrev Wa wa
    cnoreabbrev Wq wq
    cnoreabbrev wQ wq
    cnoreabbrev WQ wq
    cnoreabbrev W w
    cnoreabbrev Q q
    cnoreabbrev Qa qa
    cnoreabbrev Qall qall
    cnoreabbrev E e
]]
