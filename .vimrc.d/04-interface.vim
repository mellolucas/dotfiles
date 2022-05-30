"set shortmess+=I                   " disable startup message
"set lazyredraw                     " stop unnecessary rendering

set sidescroll=1                   " horizontal scrolling
set cc=80                          " set an 80 column border for good coding style

set number                         " show line numbers
set showcmd                        " show keys typed

set nowrap                         " no line wrapping
set breakindent                    " indent when wrapped

set fillchars=vert:▒               " split style

" tree style file explorer
let g:netrw_liststyle=3
let g:netrw_browse_split=4
let g:netrw_winsize=25

" show invisibles
set list
set listchars=
set listchars+=tab:·\ 
set listchars+=trail:·
set listchars+=extends:»
set listchars+=precedes:«
set listchars+=nbsp:░

" Highlightings
syntax on                          " syntax highlighting
set cursorline                     " highlight current cursorline
set showmatch                      " show matching brackets/parenthesis
set hlsearch                       " highlight search

" Plugins Settings ----------------------------------------
" Font
set guifont=Fira\ Code\ 11

" Theme 
let g:dracula_colorterm = 0        " Not include background fill colors
colorscheme dracula                " Enable Dracula theme

" NERDtree
let NERDTreeShowHidden = 1

" lualine
lua << END
require('lualine').setup {
  options = {theme = 'dracula'}
}
END

" lua-devicons 
lua << END
require'nvim-web-devicons'.setup {
 -- your personnal icons can go here (to override)
 -- you can specify color or cterm_color instead of specifying both of them
 -- DevIcon will be appended to `name`
 override = {
  zsh = {
    icon = "",
    color = "#428850",
    cterm_color = "65",
    name = "Zsh"
  }
 };
 -- globally enable default icons (default to false)
 -- will get overriden by `get_icons` option
 default = true;
}
END
