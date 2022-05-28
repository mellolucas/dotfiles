for filename in sort(split(glob('~/.vimrc.d/*.vim'), '\n'))
  execute 'source '.filename
endfor
