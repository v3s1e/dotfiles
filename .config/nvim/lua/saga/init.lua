local set_keymap = vim.api.nvim_set_keymap

local opts = {noremap = true, silent = true}

set_keymap('n', '<C-f>',
           '<cmd>lua require("lspsaga.action").smart_scroll_with_saga(1)<CR>',
           opts)
set_keymap('n', '<C-b>',
           '<cmd>lua require("lspsaga.action").smart_scroll_with_saga(-1)<CR>',
           opts)

set_keymap('n', '<leader>ca', '<cmd>Lspsaga code_action<CR>', opts)
set_keymap('n', 'K', '<cmd>Lspsaga hover_doc<CR>', opts)
set_keymap('n', '<leader>k', '<cmd>Lspsaga signature_help<CR>', opts)
set_keymap('n', '<leader>rn', '<cmd>Lspsaga rename<CR>', opts)
set_keymap('n', '<leader>pd', '<cmd>Lspsaga preview_definition<CR>', opts)
set_keymap('n', '<leader>e', '<cmd>Lspsaga show_line_diagnostics<CR>', opts)
set_keymap('n', '[d', '<cmd>Lspsaga diagnostic_jump_prev<CR>', opts)
set_keymap('n', ']d', '<cmd>Lspsaga diagnostic_jump_next<CR>', opts)
