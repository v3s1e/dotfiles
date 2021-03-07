local set_keymap = vim.api.nvim_set_keymap

local opts = {noremap = true, silent = true}

set_keymap('n', '<leader>ca', '<cmd>Lspsaga code_action<CR>', opts)
