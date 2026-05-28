---@type vim.lsp.Config
return {
  init_options = { hostInfo = 'neovim' },
  cmd = function(dispatchers, config)
    _ = config
    return vim.lsp.rpc.start({ 'typescript-language-server', '--stdio' }, dispatchers)
  end,
  root_dir = function(buf, on_dir)
    local markers = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock', '.git' }
    local deno_root = vim.fs.root(buf, { 'deno.json', 'deno.jsonc' })
    local deno_lock = vim.fs.root(buf, { 'deno.lock' })
    local proj_root = vim.fs.root(buf, markers)

    if deno_lock and (not proj_root or #deno_root > #proj_root) then
      return
    end
    on_dir(proj_root or vim.fn.getcwd())
  end,
  handlers = {
    ['_typescript.rename'] = function(_, res, ctx)
      local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
      vim.lsp.util.show_document({
        uri = res.textDocument.uri,
        range = {
          start = res.position,
          ['end'] = res.position,
        },
      }, client.offset_encoding)
      vim.lsp.buf.rename()
      return vim.NIL
    end,
  },
  commands = {
    ['editor.action.showReferences'] = function(cmd, ctx)
      local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
      local uri, pos, refs = unpack(cmd.arguments)

      local qfitems = vim.lsp.util.locations_to_items(refs --[[@as any]], client.offset_encoding)
      vim.fn.setqflist({}, ' ', {
        title = cmd.title,
        items = qfitems,
        context = {
          command = cmd,
          bufnr = ctx.bufnr,
        }
      })

      vim.lsp.util.show_document({
        uri = uri --[[@as string]],
        range = {
          start = pos --[[@as lsp.Position]],
          ['end'] = pos --[[@as lsp.Position]],
        },
      }, client.offset_encoding)

      vim.cmd 'botright copen'
    end,
    ---@param client vim.lsp.Client
    ---@param buf integer
    on_attach = function(client, buf)
      vim.api.nvim_buf_create_user_command(buf, 'LspTypescriptSourceAction', function()
        local source_actions = vim.tbl_filter(function(action)
          return vim.startswith(action, 'source.')
        end, client.server_capabilities.codeActionProvider.codeActionKinds)

        vim.lsp.buf.code_action({
          context = {
            only = source_actions,
            diagnostics = {},
          }
        })
      end, {})

      vim.api.nvim_buf_create_user_command(buf, 'LspTypescriptGoToSourceDefinition', function()
        local win = vim.api.nvim_get_current_win()
        local params = vim.lsp.util.make_position_params(win, client.offset_encoding)
        client:exec_cmd({
          command = '_typescript.goToSourceDefinition',
          title = 'Go to source definition',
          arguments = { params.textDocument.uri, params.position },
        }, { bufnr = buf }, function(err, res)
          if err then
            vim.notify('Go to source definiton failed: ' .. err.message, vim.log.levels.ERROR)
            return
          end
          if not res or vim.tbl_isempty(res) then
            vim.notify('No source definition found', vim.log.levels.INFO)
            return
          end
          vim.lsp.util.show_document(res[1], client.offset_encoding, { focus = true })
        end)
      end, { desc = 'Go to source definition' })
    end,
  },
}
