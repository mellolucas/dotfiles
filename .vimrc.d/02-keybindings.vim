" Exit NeoVim's terminal (`:term`) ----------
tmap <Esc> <C-\><C-n>                             

" switch between windows ----------
nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>

" Commands description:
" `tmap`s: map keys in terminal mode only
" `nmap`s: map keys in normal mode only
" `imap`s: map keys in insert mode only
" `noremap`s: non-recursively map: no propagate previous maps

