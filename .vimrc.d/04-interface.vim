"colorscheme dracula           " Dracula colorscheme

"set shortmess+=I              " disable startup message
"set lazyredraw                " stop unnecessary rendering

set sidescroll=1              " horizontal scrolling
set cc=80                     " set an 80 column border for good coding style

set number                    " show line numbers
set showcmd                   " show keys typed

set nowrap                    " no line wrapping
set breakindent               " indent when wrapped

set fillchars=vert:▒          " split style

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
syntax on                     " syntax highlighting
set cursorline                " highlight current cursorline
set showmatch                 " show matching brackets/parenthesis
set hlsearch                  " highlight search


