local lsp = require('lspconfig')

local on_attach = function(client, bufnr)
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end

    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    local opts = {noremap = true, silent = true}

    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>',
                   opts)
    buf_set_keymap('n', '<leader>wa',
                   '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<leader>wr',
                   '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<leader>wl',
                   '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>',
                   opts)
    buf_set_keymap('n', '<leader>D',
                   '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<leader>e',
                   '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>',
                   opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>',
                   opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>',
                   opts)
    buf_set_keymap('n', '<leader>q',
                   '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

    if client.resolved_capabilities.document_formatting then
        buf_set_keymap('n', '<leader>f',
                       '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
        vim.api.nvim_command(
            'autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 1000)')
    end

    if client.resolved_capabilities.document_range_formatting then
        buf_set_keymap('n', '<leader>rf',
                       '<cmd>lua vim.lsp.buf.range_formatting()<CR>', opts)
    end

    if client.resolved_capabilities.document_highlight then
        vim.api.nvim_exec([[
            hi link LspReferenceRead Visual
            hi link LspReferenceText Visual
            hi link LspReferenceWrite Visual
            augroup lsp_document_highlight
                autocmd! * <buffer>
                autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
                autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
            augroup END
        ]], false)
    end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local linters = {
    eslint_d = require('efm/linters/eslint_d'),
    markdownlint = require('efm/linters/markdownlint')
}

local formatters = {
    luaFormat = require('efm/formatters/lua-format'),
    prettier = require('efm/formatters/prettier')
}

lsp.efm.setup({
    filetypes = {
        'lua', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact',
        'json', 'css', 'sass', 'scss', 'html', 'markdown'
    },
    init_options = {documentFormatting = true},
    settings = {
        languages = {
            lua = {formatters.luaFormat},
            javascript = {linters.eslint_d, formatters.prettier},
            javascriptreact = {linters.eslint_d, formatters.prettier},
            typescript = {linters.eslint_d, formatters.prettier},
            typescriptreact = {linters.eslint_d, formatters.prettier},
            json = {formatters.prettier},
            css = {formatters.prettier},
            sass = {formatters.prettier},
            scss = {formatters.prettier},
            html = {formatters.prettier},
            markdown = {linters.markdownlint}
        }
    },
    capabilities = capabilities,
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
    capabilities = capabilities,
    on_attach = on_attach
})

local servers = {
    'vimls', 'bashls', 'tsserver', 'jsonls', 'cssls', 'html', 'pyls', 'jdtls',
    'rust_analyzer', 'clangd'
}
for _, server in ipairs(servers) do
    lsp[server].setup({capabilities = capabilities, on_attach = on_attach})
end
