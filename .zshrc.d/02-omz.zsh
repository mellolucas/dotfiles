# Oh My Zsh | Theme ----------------------------------------
ZSH_THEME="dracula"                                         # OMZ Themes (see github ohmyzsh/ohmyzsh/wiki/Themes)
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )  # Randomize theme

# Oh My Zsh | Updates ----------------------------------------
zstyle ':omz:update' mode auto                              # update automatically without asking
# zstyle ':omz:update' mode reminder                         # just remind me to update when it's time
zstyle ':omz:update' frequency 13                           # how often to auto-update (in days)

# Oh My Zsh | Options ----------------------------------------
COMPLETION_WAITING_DOTS="true"                              # Display red dots whilst waiting for completion (omz) 
HIST_STAMPS="yyyy-mm-dd"                                    # Time stamp format within history command output
# Oh My Zsh | Dracula Theme | Options ----------
# DRACULA_DISPLAY_CONTEXT=1
# DRACULA_DISPLAY_TIME=1
DRACULA_ARROW_ICON="%B λ%b"
# DRACULA_DISPLAY_NEW_LINE=1

# Oh My Zsh | Plugins ----------------------------------------
plugins=(
  git
  vi-mode
  1password
  zsh-autosuggestions
  zsh-syntax-highlighting
)                                                           # Git prompt
# Oh My Zsh | vi-mode | Options ----------
VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
VI_MODE_SET_CURSOR=true

# Oh My Zsh | Source ----------------------------------------
source $ZSH/oh-my-zsh.sh                                    # Source OMZ script


