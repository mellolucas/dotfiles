# main ----------------------------------------
alias cls='clear'                       # clear screen
alias ll="ls -pilhA --color=auto"       # list long
alias lm="ls -phA --color=auto"         # list minimal
alias lgrep="ls -phA | grep"            # list pwd and grep
alias ncat="cat --number"               # numbered cat
alias shred="sudo shred -vuz"

# git ----------------------------------------
alias g="git"
alias ga="git add"
alias gc="git commit -m"
alias gs="git status"
alias gd="git diff"
alias gf="git fetch"
alias gm="git merge"
alias gr="git rebase"
alias gp="git push"
alias gu="git unstage"
alias gg="git graph"
alias ggg="git graphgpg"
alias gco="git checkout"
alias gcs="git commit -S -m"
alias gpr="hub pull-request"

# Applications ----------------------------------------
[[ $(command -v nvim) ]] && alias vim="nvim"
alias svim="sudoedit"
alias ansp="ansible-playbook"
alias vansp="ansible-playbook -v"
[[ $(command -v nerdctl) ]] && alias docker="nerdctl"
alias nerd="nerdctl"
alias k8="kubectl"

# Misc ----------------------------------------
alias lol="base64 </dev/urandom | lolcat"
alias matrix="cmatrix -b"
alias zen="while :; do bonsai -l -b 2 -c oO0 -t 0.5; sleep 10; done"

