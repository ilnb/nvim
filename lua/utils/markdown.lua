local active_previews = {}
local augroup = vim.api.nvim_create_augroup('MarkdownPreview', { clear = true })

local compiler_cmd = 'pandoc'

local function wrap_html(version_file, body)
  local head = [[
  <!DOCTYPE html>
  <html>
  <head>
    <meta charset="utf-8">
    <title>Markdown Preview</title>
    <style>
      body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial, sans-serif; max-width: 850px; margin: 0 auto; padding: 2rem; line-height: 1.6; color: #c9d1d9; background-color: #0d1117; }
      h1, h2, h3, h4, h5, h6 { color: #e6edf3; }
      a { color: #58a6ff; text-decoration: none; }
      a:hover { text-decoration: underline; }
      pre { background: #161b22; padding: 16px; border-radius: 6px; overflow: auto; }
      code { font-family: ui-monospace, SFMono-Regular, "SF Mono", monospace; background: rgba(110,118,129,0.4); padding: 0.2em 0.4em; border-radius: 3px; }
      pre code { background: none; padding: 0; }
      blockquote { border-left: 4px solid #30363d; padding: 0 1em; color: #8b949e; margin-left: 0; }
      img { max-width: 100%; }
      table { border-collapse: collapse; width: 100%; }
      th, td { border: 1px solid #30363d; padding: 6px 13px; }
      tr:nth-child(2n) { background-color: #1c2128; }
    </style>

    <script>
      MathJax = {
        tex: {
          inlineMath: [ ['$','$'], ['\\(','\\)'] ],
          displayMath: [ ['$$','$$'], ['\\[','\\]'] ]
        },
        svg: { fontCache: 'global' }
      };
    </script>
    <script id="MathJax-script" async src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js"></script>
  </head>
  <body>
  ]]

  local foot = [[
    <script>
      document.addEventListener("DOMContentLoaded", function() {
        var scrollPos = sessionStorage.getItem('scrollPosition');
        if (scrollPos) window.scrollTo(0, parseInt(scrollPos));
      });
      window.addEventListener("beforeunload", function() {
        sessionStorage.setItem('scrollPosition', window.scrollY);
      });

      var currentVersion = null;
      setInterval(function() {
        var script = document.createElement("script");
        script.src = "]] .. version_file .. [[#" + new Date().getTime();
        script.onload = function() {
          if (currentVersion === null) {
            currentVersion = window.MARKDOWN_VERSION;
          } else if (currentVersion !== window.MARKDOWN_VERSION) {
            location.reload();
          }
          script.remove();
        };
        script.onerror = function() { script.remove(); };
        document.head.appendChild(script);
      }, 1000);
    </script>
  </body>
  </html>
  ]]

  return head .. body .. foot
end

local function open_in_browser(filepath)
  local sysname = vim.uv.os_uname().sysname
  local cmd = { 'xdg-open', filepath }

  if sysname == 'Darwin' then
    cmd = { 'open', filepath }
  elseif sysname:match 'Windows' then
    cmd = { 'cmd.exe', '/c', 'start', filepath }
  end

  vim.system(cmd, { detach = true })
end

local function compile_markdown(buffer)
  local state = active_previews[buffer]
  if not state or not state.is_active then return end

  local buf_path = vim.api.nvim_buf_get_name(buffer)
  if buf_path == '' or not buf_path:match '%.md$' then return end

  local cmd = { compiler_cmd, buf_path, '-t', 'html', '--mathjax' }
  local html_out = {}
  local version_filename = vim.fn.fnamemodify(state.version_file, ':t')

  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data then
        for _, line in ipairs(data) do
          table.insert(html_out, line)
        end
      end
    end,
    on_exit = function(_, code)
      if code == 0 then
        local body = table.concat(html_out, '\n')
        local html_content = wrap_html(version_filename, body)

        local f = io.open(state.tmp_file, 'w')
        if f then
          f:write(html_content)
          f:close()
        end

        local vf = io.open(state.version_file, 'w')
        if vf then
          vf:write("window.MARKDOWN_VERSION = " .. vim.uv.now() .. ";")
          vf:close()
        end

        if not state.has_opened then
          open_in_browser(state.tmp_file)
          state.has_opened = true
        end
      else
        vim.notify('Markdown Preview: Compilation failed.', vim.log.levels.ERROR)
      end
    end
  })
end

local function start_preview()
  local buffer = vim.api.nvim_get_current_buf()
  if active_previews[buffer] and active_previews[buffer].is_active then return end

  if vim.fn.executable(compiler_cmd) == 0 then
    vim.notify("Markdown Preview: '" .. compiler_cmd .. "' not found in PATH.", vim.log.levels.ERROR)
    return
  end

  local base_name = vim.fn.tempname()
  active_previews[buffer] = {
    is_active = true,
    has_opened = false,
    tmp_file = base_name .. '.html',
    version_file = base_name .. '_version.js'
  }

  compile_markdown(buffer)

  vim.api.nvim_create_autocmd('BufWritePost', {
    group = augroup,
    buffer = buffer,
    callback = function() compile_markdown(buffer) end,
  })

  vim.notify('Markdown Preview Started (Buffer ' .. buffer .. ')', vim.log.levels.INFO)
end

local function stop_preview()
  local buffer = vim.api.nvim_get_current_buf()
  if not active_previews[buffer] or not active_previews[buffer].is_active then return end

  active_previews[buffer] = nil
  vim.api.nvim_clear_autocmds({ group = augroup, buffer = buffer })

  vim.notify('Markdown Preview Stopped (Buffer ' .. buffer .. ')', vim.log.levels.INFO)
end

local function toggle_preview()
  local buffer = vim.api.nvim_get_current_buf()
  if active_previews[buffer] and active_previews[buffer].is_active then
    stop_preview()
  else
    start_preview()
  end
end

vim.api.nvim_create_user_command('MarkdownPreview', start_preview, {})
vim.api.nvim_create_user_command('MarkdownPreviewStop', stop_preview, {})
vim.api.nvim_create_user_command('MarkdownPreviewToggle', toggle_preview, {})

vim.keymap.set('n', '<leader>mp', '<cmd>MarkdownPreviewToggle<CR>', { silent = true, desc = 'Toggle Markdown Preview' })
