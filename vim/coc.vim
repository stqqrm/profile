" coc.vim
let g:coc_user_config = {'inlayHint.enable': v:false}

" --- CoC settings --- 
let g:coc_user_config = {
  \ 'semanticTokens.enable': v:true
\ }

" --- CoC extensions --- 
let g:coc_global_extensions = ['coc-clangd']

" --- Completion --- 
" Ctrl+F triggers completion; if menu is visible, confirm selection
inoremap <silent><expr> <C-f>
	  \ coc#pum#visible() ? coc#pum#confirm() : coc#refresh()
inoremap <silent><expr> <Up>   coc#pum#visible() ? coc#pum#prev(1) : "\<Up>"
inoremap <silent><expr> <Down> coc#pum#visible() ? coc#pum#next(1) : "\<Down>"
inoremap <silent><expr> <Esc> coc#pum#visible() ? coc#pum#cancel() : "\<Esc>"
nmap <silent> <Leader>ca <Plug>(coc-codeaction)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

