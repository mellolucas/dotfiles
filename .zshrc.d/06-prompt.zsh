# Prompt Display ----------------------------------------
# PS1=                                                       # set PS1
#                                                            # enable syntax highlighting
# Prompt Feedback ----------------------------------------
unsetopt beep                                               # no beeps on errors

# Vi Prompt Cursor ----------------------------------------
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} == '' ]] ||
       [[ $1 == 'line' ]]; then
    echo -ne '\e[1 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
  zle -K viins
  echo -ne '\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[1 q'                           # default to block cursor
preexec() { echo -ne '\e[1 q'; }            # use block cursor on each new prompt
