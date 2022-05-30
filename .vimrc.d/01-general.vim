" General ----------------------------------------
set nocompatible              " explicitly disable compatibility to old-time vi
set exrc                      " Override in projects with local .nvimrc
filetype plugin on            " Allow scripts to run for specific file types
filetype plugin indent on     "allow auto-indenting depending on file type
set encoding=utf8

" Usage ----------------------------------------
set splitright                " open new split panes to right
set splitbelow                " open new split panes below
set ttyfast                   " Speed up scrolling in Vim
set mouse=a                   " enable mouse click
"set clipboard=unnamedplus    " using system clipboard
"set spell                    " enable spell check (may need to download language package)
set incsearch                 " incremental search
set ignorecase                " case insensitive search
set smartcase                 " case insensitive search
set infercase                 " case insensitive search

" Tab preferences ----------------------------------------
set tabstop=2                 " number of columns occupied by a tab
set softtabstop=2             " see multiple spaces as tabstops so <BS> does the right thing
set shiftwidth=2              " width for autoindents
set expandtab                 " converts tabs to white space
set autoindent                " indent a new line the same amount as the line just typed
set wildmode=longest,list     " get bash-like tab completions
