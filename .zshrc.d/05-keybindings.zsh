# Thanks @xero and @MentalOutlaw

# Capture Nav Keys ----------------------------------------
typeset -A key
bindkey -v # vi keys
key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# Bind Nav Keys ----------------------------------------
[[ -n "${key[Home]}"     ]]  && bindkey  "${key[Home]}"     beginning-of-line
[[ -n "${key[End]}"      ]]  && bindkey  "${key[End]}"      end-of-line
[[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"   overwrite-mode
[[ -n "${key[Delete]}"   ]]  && bindkey  "${key[Delete]}"   delete-char
[[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"       up-line-or-history
[[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"     down-line-or-history
[[ -n "${key[Left]}"     ]]  && bindkey  "${key[Left]}"     backward-char
[[ -n "${key[Right]}"    ]]  && bindkey  "${key[Right]}"    forward-char
[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"   beginning-of-buffer-or-history
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}" end-of-buffer-or-history

# Bind History Search Keys ----------------------------------------
bindkey '^r' history-incremental-search-backward
bindkey '^R' history-incremental-pattern-search-backward

# Bind Vi Keys ----------------------------------------
bindkey -v # vi keys
KEYTIMEOUT=1
bindkey -M menuselect 'h'                                   vi-backward-char        # Vi nav mode on menu
bindkey -M menuselect 'k'                                   vi-up-line-or-history   # Vi nav mode on menu
bindkey -M menuselect 'l'                                   vi-forward-char         # Vi nav mode on menu
bindkey -M menuselect 'j'                                   vi-down-line-or-history # Vi nav mode on menu
bindkey -v '^?'                                             backward-delete-char    # Vi delete key
