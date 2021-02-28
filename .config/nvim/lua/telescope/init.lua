local set_keymap = vim.api.nvim_set_keymap

local opts = {noremap = true}

set_keymap('n', '<leader>gf', '<cmd>Telescope find_files<CR>', opts)
set_keymap('n', '<leader>gg', '<cmd>Telescope live_grep<CR>', opts)
set_keymap('n', '<leader>gb', '<cmd>Telescope buffers<CR>', opts)
set_keymap('n', '<leader>gh', '<cmd>Telescope help_tags<CR>', opts)

set_keymap('n', '<leader>gd', '<cmd>Telescope lsp_document_symbols<CR>', opts)
set_keymap('n', '<leader>gw', '<cmd>Telescope lsp_workspace_symbols<CR>', opts)

set_keymap('n', 'gr', '<cmd>Telescope lsp_references<CR>', opts)
set_keymap('n', '<leader>ga', '<cmd>Telescope lsp_code_actions<CR>', opts)
