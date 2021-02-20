local lsp = require('lspconfig')

local on_attach = function(client, bufnr)
    local function nvim_buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end
    local function nvim_buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    nvim_buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    local opts = {noremap = true, silent = true}
    nvim_buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>',
                        opts)
    nvim_buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    nvim_buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    nvim_buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>',
                        opts)
    nvim_buf_set_keymap('n', '<C-k>',
                        '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    nvim_buf_set_keymap('n', '<space>wa',
                        '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    nvim_buf_set_keymap('n', '<space>wr',
                        '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>',
                        opts)
    nvim_buf_set_keymap('n', '<space>wl',
                        '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>',
                        opts)
    nvim_buf_set_keymap('n', '<space>D',
                        '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    nvim_buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>',
                        opts)
    nvim_buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    nvim_buf_set_keymap('n', '<space>e',
                        '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>',
                        opts)
    nvim_buf_set_keymap('n', '[d',
                        '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    nvim_buf_set_keymap('n', ']d',
                        '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    nvim_buf_set_keymap('n', '<space>q',
                        '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

    nvim_buf_set_keymap('n', '<space>f',
                        '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
    nvim_buf_set_keymap('n', '<space>rf',
                        '<cmd>lua vim.lsp.buf.range_formatting()<CR>', opts)
    vim.api.nvim_command(
        'autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 1000)')

    vim.api.nvim_exec([[
    hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
    hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
    hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
    augroup lsp_document_highlight
      autocmd! * <buffer>
      autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
      autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    augroup END
  ]], false)
end

lsp.diagnosticls.setup({
    filetypes = {
        'lua', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact',
        'json', 'css', 'sass', 'scss', 'html', 'markdown'
    },
    init_options = {
        linters = {
            eslint = {
                command = 'eslint',
                rootPatterns = {'.git'},
                debounce = 100,
                args = {
                    '--stdin', '--stdin-filename', '%filepath', '--format',
                    'json'
                },
                sourceName = 'eslint',
                parseJson = {
                    errorsRoot = '[0].messages',
                    line = 'line',
                    column = 'column',
                    endLine = 'endLine',
                    endColumn = 'endColumn',
                    message = '[eslint] ${message} [${ruleId}]',
                    security = 'severity'
                },
                securities = {[2] = 'error', [1] = 'warning'}
            },
            markdownlint = {
                command = 'markdownlint',
                rootPatterns = {'.git'},
                isStderr = true,
                debounce = 100,
                args = {'--stdin'},
                offsetLine = 0,
                offsetColumn = 0,
                sourceName = 'markdownlint',
                securities = {undefined = 'hint'},
                formatLines = 1,
                formatPattern = {
                    '^.*:(\\d+)\\s+(.*)$', {line = 1, column = -1, message = 2}
                }
            }
        },
        filetypes = {
            javascript = 'eslint',
            javascriptreact = 'eslint',
            typescript = 'eslint',
            typescriptreact = 'eslint',
            markdown = 'markdownlint'
        },
        formatters = {
            ['lua-format'] = {command = 'lua-format', args = {'-i'}},
            prettier = {
                command = 'prettier',
                args = {'--stdin-filepath', '%filename'}
            }
        },
        formatFiletypes = {
            lua = 'lua-format',
            javascript = 'prettier',
            javascriptreact = 'prettier',
            typescript = 'prettier',
            typescriptreact = 'prettier',
            json = 'prettier',
            css = 'prettier',
            sass = 'prettier',
            scss = 'prettier',
            html = 'prettier'
        }
    },
    on_attach = on_attach
})

local lua_language_server = vim.fn.expand(
                                '$HOME/.local/share/nvim/lua-language-server')
local lua_language_server_binary = lua_language_server ..
                                       '/bin/macOS/lua-language-server'
local lua_language_server_main = lua_language_server .. '/main.lua'

lsp.sumneko_lua.setup({
    cmd = {lua_language_server_binary, '-E', lua_language_server_main},
    settings = {
        Lua = {
            runtime = {version = 'LuaJIT', path = vim.split(package.path, ';')},
            diagnostics = {globals = {'vim'}},
            workspace = {
                library = {
                    [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                    [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true
                }
            }
        }
    },
    on_attach = on_attach
})

local servers = {
    'vimls', 'bashls', 'tsserver', 'jsonls', 'cssls', 'html', 'pyls', 'jdtls',
    'rust_analyzer', 'clangd'
}
for _, server in ipairs(servers) do lsp[server].setup({on_attach = on_attach}) end
