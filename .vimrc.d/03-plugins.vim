" Prepare Plugin Manager (vim-plug) ----------------------------------------
" Set path
set runtimepath+=~/.vimrc.d/

" Install vim-plug if not found
if empty(glob('~/.vimrc.d/autoload/plug.vim'))
  silent !curl -fLo ~/.vimrc.d/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif


" Plugins ----------------------------------------
call plug#begin('~/.vimrc.d/plugged')
  Plug 'dhruvasagar/vim-table-mode'                           " auto table creator and formatter
  Plug 'scrooloose/nerdtree'                                  " file system explorer
  Plug 'neoclide/coc.nvim', {'branch': 'release'}             " completion, linting and formatting
  Plug 'github/copilot.vim'                                   " Github Copilot
  Plug 'tpope/vim-fugitive'                                   " git wrapper (`:G` or `Git`)
  Plug 'dracula/vim', { 'as': 'dracula' }                     " Dracula theme and colorscheme
  Plug 'nvim-lualine/lualine.nvim'                            " statusline
  Plug 'kyazdani42/nvim-web-devicons'                         " devicons support
call plug#end()
