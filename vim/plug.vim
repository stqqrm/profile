" --- Bootstrap vim-plug --- 
let plug_file = expand('~/.vim/autoload/plug.vim')
if empty(glob(plug_file))
	silent execute '!curl -fLo ' . plug_file . ' --create-dirs
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	autocmd VimEnter * PlugInstall --sync | source /etc/vimrc
endif

" --- Plugins ---
call plug#begin('~/.vim/plugged')
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
	Plug 'dense-analysis/ale'
	Plug 'jiangmiao/auto-pairs'
	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
	Plug 'junegunn/fzf.vim'
	Plug 'stqqrm/bex.vim'
    Plug 'wellle/context.vim'
call plug#end()

" --- Auto-install missing plugins ---
autocmd VimEnter *
  \ if len(filter(values(g:plugs), '!isdirectory(v:val.dir)')) > 0
  \|   PlugInstall --sync
  \|   source /etc/vimrc
  \| endif
