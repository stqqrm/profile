" Bootstrap plug.vim 
let plug_file = expand('~/.vim/autoload/plug.vim')
if empty(glob(plug_file))
	silent execute '!curl -fLo ' . plug_file . ' --create-dirs
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	autocmd VimEnter * PlugInstall --sync | source /etc/vimrc
endif

call plug#begin('~/.vim/plugged')
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
	Plug 'dense-analysis/ale'
	Plug 'jiangmiao/auto-pairs'
	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
	Plug 'junegunn/fzf.vim'
	Plug 'stqqrm/bex.vim'
	Plug 'stqqrm/clangd-manager.vim'
	Plug 'wellle/context.vim'
call plug#end()

" Install missing packages
augroup AutoInstallPlugins
	autocmd!
	autocmd VimEnter * nested
		\ if len(filter(values(g:plugs), '!isdirectory(v:val.dir)')) > 0
		\|   PlugInstall --sync
		\|   call input("Press ENTER to continue...")
		\|   q
		\|   execute 'set runtimepath+=' . fnameescape(g:plug_home)
		\|   doautocmd VimEnter
		\| endif
augroup END
