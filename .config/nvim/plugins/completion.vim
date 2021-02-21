lua require('completion')

set completeopt=menuone,noselect
set shortmess+=c

inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <Tab>     v:lua.tab_complete()
snoremap <silent><expr> <Tab>     v:lua.tab_complete()
inoremap <silent><expr> <S-Tab>   v:lua.s_tab_complete()
snoremap <silent><expr> <S-Tab>   v:lua.s_tab_complete()
