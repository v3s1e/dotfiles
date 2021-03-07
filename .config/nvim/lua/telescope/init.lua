local set_keymap = vim.api.nvim_set_keymap

local opts = {noremap = true}

set_keymap('n', '<leader>gf', '<cmd>Telescope find_files<CR>', opts)
set_keymap('n', '<leader>gg', '<cmd>Telescope live_grep<CR>', opts)
set_keymap('n', '<leader>gb', '<cmd>Telescope buffers<CR>', opts)
set_keymap('n', '<leader>gh', '<cmd>Telescope help_tags<CR>', opts)

set_keymap('n', '<leader>sd', '<cmd>Telescope lsp_document_symbols<CR>', opts)
set_keymap('n', '<leader>qd', '<cmd>Telescope lsp_document_diagnostics<CR>',
           opts)

set_keymap('n', '<leader>sw', '<cmd>Telescope lsp_workspace_symbols<CR>', opts)
set_keymap('n', '<leader>qw', '<cmd>Telescope lsp_workspace_diagnostics<CR>',
           opts)

set_keymap('n', 'gr', '<cmd>Telescope lsp_references<CR>', opts)
