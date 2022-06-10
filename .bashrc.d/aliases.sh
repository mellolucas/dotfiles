if [ -d $HOME/.zshrc.d ]; then
  for file in $HOME/.zshrc.d/*alias*; do
    if [ -f "$file" ]; then
      . "$file"
    fi
  done
fi
