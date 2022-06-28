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
  options = {
    icons_enabled = true,
    theme = 'dracula',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
    always_divide_middle = true,
    globalstatus = false,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
}
END
