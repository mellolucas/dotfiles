
# Oh My Zsh paths ----------------------------------------
export ZSH="$HOME/projects/dotfiles/.ohmyzsh.d"


# History ----------------------------------------
HISTFILE=/$HOME/.zsh_history
HISTSIZE=2814
SAVEHIST=5628

# Misc options ----------------------------------------
unsetopt beep # no beeps on errors
bindkey -v # vi keys

# Completion ----------------------------------------
zstyle ':completion:*' auto-description '(%d)'
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' file-sort name
zstyle ':completion:*' format 'ASASAS %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' ignore-parents parent pwd ..
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or type the character to insert%s'
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=** r:|=** l:|=*'
zstyle ':completion:*' menu select=3
zstyle ':completion:*' original true
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' select-prompt '%S%l%s'
zstyle ':completion:*' verbose true
zstyle :compinstall filename '/home/lufom/.zshrc'

autoload -Uz compinit
compinit

# Oh My Zsh Plugins ----------------------------------------
plugins=(git)
source $ZSH/oh-my-zsh.sh


# Aesthetics ----------------------------------------
ZSH_THEME="dracula" ## omz theme
